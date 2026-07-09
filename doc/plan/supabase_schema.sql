-- ============================================================
-- Supabase Schema für "Pizzeria Pepe et Urinal"
-- 
-- Dieses SQL-Skript definiert alle Tabellen, Spalten,
-- Constraints, Indizes und Row-Level-Security (RLS)-Policies.
--
-- Import in Supabase:
--   1. Supabase Dashboard → SQL Editor → New Query
--   2. Dieses Skript einfügen und ausführen
-- ============================================================

-- ============================================================
-- 1. profiles
-- Erweitert die Supabase Auth Users um ein öffentliches Profil
-- ============================================================
CREATE TABLE IF NOT EXISTS public.profiles (
    id          UUID        PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email       TEXT        NOT NULL,
    full_name   TEXT,
    role        TEXT        NOT NULL DEFAULT 'user' CHECK (role IN ('admin', 'user')),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Automatisch ein Profil anlegen, wenn ein neuer User registriert wird
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = public
AS $$
BEGIN
    INSERT INTO public.profiles (id, email, full_name, role)
    VALUES (
        NEW.id,
        NEW.email,
        NEW.raw_user_meta_data ->> 'full_name',
        COALESCE(NEW.raw_user_meta_data ->> 'role', 'user')
    );
    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

-- Index für E-Mail-Suche
CREATE INDEX IF NOT EXISTS idx_profiles_email ON public.profiles(email);

-- RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Jeder kann sein eigenes Profil sehen
CREATE POLICY "Users can view own profile"
    ON public.profiles
    FOR SELECT
    USING (auth.uid() = id);

-- Jeder kann sein eigenes Profil aktualisieren
CREATE POLICY "Users can update own profile"
    ON public.profiles
    FOR UPDATE
    USING (auth.uid() = id);

-- ============================================================
-- 2. categories
-- Produktkategorien (z. B. Pizza Klassisch, Pizza Spezial, Pasta)
-- ============================================================
CREATE TABLE IF NOT EXISTS public.categories (
    id          BIGINT      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name        TEXT        NOT NULL,
    slug        TEXT        NOT NULL UNIQUE,
    description TEXT,
    sort_order  INTEGER     NOT NULL DEFAULT 0,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_categories_slug ON public.categories(slug);
CREATE INDEX IF NOT EXISTS idx_categories_sort ON public.categories(sort_order);

-- RLS
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;

-- Jeder (auch nicht eingeloggt) kann Kategorien lesen
CREATE POLICY "Anyone can view categories"
    ON public.categories
    FOR SELECT
    USING (true);

-- Nur Admins können Kategorien verwalten
CREATE POLICY "Admins can insert categories"
    ON public.categories
    FOR INSERT
    WITH CHECK (
        EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
    );

CREATE POLICY "Admins can update categories"
    ON public.categories
    FOR UPDATE
    USING (
        EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
    );

CREATE POLICY "Admins can delete categories"
    ON public.categories
    FOR DELETE
    USING (
        EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
    );

-- ============================================================
-- 3. articles
-- Blog-Artikel / News (CMS)
-- ============================================================
CREATE TABLE IF NOT EXISTS public.articles (
    id              BIGINT          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title           TEXT            NOT NULL,
    slug            TEXT            NOT NULL UNIQUE,
    content         TEXT            NOT NULL,           -- Rich-Text (HTML)
    excerpt         TEXT,                                -- Kurztext für Vorschau
    featured_image  TEXT,                                -- URL zum Bild in Supabase Storage
    author_id       UUID            NOT NULL REFERENCES public.profiles(id) ON DELETE SET NULL,
    status          TEXT            NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'published')),
    published_at    TIMESTAMPTZ,
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_articles_slug ON public.articles(slug);
CREATE INDEX IF NOT EXISTS idx_articles_status ON public.articles(status);
CREATE INDEX IF NOT EXISTS idx_articles_published_at ON public.articles(published_at DESC);
CREATE INDEX IF NOT EXISTS idx_articles_author ON public.articles(author_id);

-- RLS
ALTER TABLE public.articles ENABLE ROW LEVEL SECURITY;

-- Veröffentlichte Artikel dürfen alle sehen
CREATE POLICY "Anyone can view published articles"
    ON public.articles
    FOR SELECT
    USING (status = 'published');

-- Admins dürfen alle Artikel sehen (auch Entwürfe)
CREATE POLICY "Admins can view all articles"
    ON public.articles
    FOR SELECT
    USING (
        EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
    );

-- Nur Admins können Artikel schreiben/bearbeiten/löschen
CREATE POLICY "Admins can insert articles"
    ON public.articles
    FOR INSERT
    WITH CHECK (
        EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
    );

CREATE POLICY "Admins can update articles"
    ON public.articles
    FOR UPDATE
    USING (
        EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
    );

CREATE POLICY "Admins can delete articles"
    ON public.articles
    FOR DELETE
    USING (
        EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
    );

-- Automatisch updated_at setzen
CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;

CREATE TRIGGER set_articles_updated_at
    BEFORE UPDATE ON public.articles
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at();

-- ============================================================
-- 4. products
-- Produkte für den Shop (Speisekarte)
-- ============================================================
CREATE TABLE IF NOT EXISTS public.products (
    id              BIGINT          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name            TEXT            NOT NULL,
    slug            TEXT            NOT NULL UNIQUE,
    description     TEXT,
    price           NUMERIC(10, 2)  NOT NULL CHECK (price >= 0),
    compare_price   NUMERIC(10, 2)  CHECK (compare_price IS NULL OR compare_price > price),
    image_url       TEXT,
    category_id     BIGINT          REFERENCES public.categories(id) ON DELETE SET NULL,
    is_available    BOOLEAN         NOT NULL DEFAULT TRUE,
    is_featured     BOOLEAN         NOT NULL DEFAULT FALSE,
    sort_order      INTEGER         NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_products_slug ON public.products(slug);
CREATE INDEX IF NOT EXISTS idx_products_category ON public.products(category_id);
CREATE INDEX IF NOT EXISTS idx_products_available ON public.products(is_available);
CREATE INDEX IF NOT EXISTS idx_products_featured ON public.products(is_featured);
CREATE INDEX IF NOT EXISTS idx_products_sort ON public.products(sort_order);

-- RLS
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

-- Jeder kann verfügbare Produkte sehen
CREATE POLICY "Anyone can view available products"
    ON public.products
    FOR SELECT
    USING (is_available = TRUE);

-- Admins dürfen alle Produkte sehen (auch nicht verfügbare)
CREATE POLICY "Admins can view all products"
    ON public.products
    FOR SELECT
    USING (
        EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
    );

-- Nur Admins können Produkte verwalten
CREATE POLICY "Admins can insert products"
    ON public.products
    FOR INSERT
    WITH CHECK (
        EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
    );

CREATE POLICY "Admins can update products"
    ON public.products
    FOR UPDATE
    USING (
        EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
    );

CREATE POLICY "Admins can delete products"
    ON public.products
    FOR DELETE
    USING (
        EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
    );

CREATE TRIGGER set_products_updated_at
    BEFORE UPDATE ON public.products
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at();

-- ============================================================
-- 5. subscribers
-- Newsletter-Abonnenten (lokale Kopie; Hauptverwaltung in Brevo)
-- ============================================================
CREATE TABLE IF NOT EXISTS public.subscribers (
    id              BIGINT          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    email           TEXT            NOT NULL UNIQUE,
    name            TEXT,
    status          TEXT            NOT NULL DEFAULT 'pending'
                                        CHECK (status IN ('pending', 'active', 'unsubscribed', 'bounced')),
    brevo_id        BIGINT,                             -- ID in Brevo zur Synchronisation
    subscribed_at   TIMESTAMPTZ,
    unsubscribed_at TIMESTAMPTZ,
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_subscribers_email ON public.subscribers(email);
CREATE INDEX IF NOT EXISTS idx_subscribers_status ON public.subscribers(status);

-- RLS
ALTER TABLE public.subscribers ENABLE ROW LEVEL SECURITY;

-- Jeder kann sich selbst eintragen (INSERT)
CREATE POLICY "Anyone can subscribe"
    ON public.subscribers
    FOR INSERT
    WITH CHECK (true);

-- Nur Admins können Abonnenten sehen/verwalten
CREATE POLICY "Admins can view subscribers"
    ON public.subscribers
    FOR SELECT
    USING (
        EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
    );

CREATE POLICY "Admins can update subscribers"
    ON public.subscribers
    FOR UPDATE
    USING (
        EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
    );

CREATE POLICY "Admins can delete subscribers"
    ON public.subscribers
    FOR DELETE
    USING (
        EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
    );

-- ============================================================
-- 6. orders
-- Bestellungen (Shop)
-- ============================================================
CREATE TABLE IF NOT EXISTS public.orders (
    id              BIGINT          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_name   TEXT            NOT NULL,
    customer_email  TEXT            NOT NULL,
    customer_phone  TEXT,
    status          TEXT            NOT NULL DEFAULT 'pending'
                                        CHECK (status IN ('pending', 'confirmed', 'preparing', 'ready', 'completed', 'cancelled')),
    pickup_time     TIMESTAMPTZ,                        -- Vom Kunden gewünschter Abholzeitpunkt
    notes           TEXT,                                -- Z. B. Allergene, Sonderwünsche
    total_amount    NUMERIC(10, 2)  NOT NULL CHECK (total_amount >= 0),
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_orders_status ON public.orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_created ON public.orders(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_pickup ON public.orders(pickup_time);

-- RLS
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

-- Jeder kann eine Bestellung aufgeben (INSERT)
CREATE POLICY "Anyone can create orders"
    ON public.orders
    FOR INSERT
    WITH CHECK (true);

-- Nur Admins können Bestellungen sehen/verwalten
CREATE POLICY "Admins can view orders"
    ON public.orders
    FOR SELECT
    USING (
        EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
    );

CREATE POLICY "Admins can update orders"
    ON public.orders
    FOR UPDATE
    USING (
        EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
    );

CREATE TRIGGER set_orders_updated_at
    BEFORE UPDATE ON public.orders
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at();

-- ============================================================
-- 7. order_items
-- Bestellpositionen (ein Produkt in einer Bestellung)
-- ============================================================
CREATE TABLE IF NOT EXISTS public.order_items (
    id              BIGINT          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id        BIGINT          NOT NULL REFERENCES public.orders(id) ON DELETE CASCADE,
    product_id      BIGINT          NOT NULL REFERENCES public.products(id) ON DELETE RESTRICT,
    product_name    TEXT            NOT NULL,            -- Redundanz, falls Produkt später gelöscht wird
    quantity        INTEGER         NOT NULL CHECK (quantity > 0),
    unit_price      NUMERIC(10, 2)  NOT NULL CHECK (unit_price >= 0),
    total_price     NUMERIC(10, 2)  NOT NULL CHECK (total_price >= 0),
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_order_items_order ON public.order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product ON public.order_items(product_id);

-- RLS
ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;

-- Jeder kann Bestellpositionen anlegen (beim Bestellvorgang)
CREATE POLICY "Anyone can create order items"
    ON public.order_items
    FOR INSERT
    WITH CHECK (true);

-- Nur Admins können Bestellpositionen sehen
CREATE POLICY "Admins can view order items"
    ON public.order_items
    FOR SELECT
    USING (
        EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
    );

-- ============================================================
-- 8. newsletter_campaigns
-- Gespeicherte Newsletter-Kampagnen (CRM)
-- ============================================================
CREATE TABLE IF NOT EXISTS public.newsletter_campaigns (
    id              BIGINT          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    subject         TEXT            NOT NULL,
    content         TEXT            NOT NULL,            -- HTML-Inhalt
    sent_at         TIMESTAMPTZ,                        -- NULL = noch nicht gesendet
    recipient_count INTEGER,                             -- Anzahl der Empfänger
    created_by      UUID            NOT NULL REFERENCES public.profiles(id) ON DELETE SET NULL,
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_newsletter_campaigns_sent ON public.newsletter_campaigns(sent_at);

-- RLS
ALTER TABLE public.newsletter_campaigns ENABLE ROW LEVEL SECURITY;

-- Nur Admins können Kampagnen sehen/verwalten
CREATE POLICY "Admins can view campaigns"
    ON public.newsletter_campaigns
    FOR SELECT
    USING (
        EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
    );

CREATE POLICY "Admins can insert campaigns"
    ON public.newsletter_campaigns
    FOR INSERT
    WITH CHECK (
        EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
    );

CREATE POLICY "Admins can update campaigns"
    ON public.newsletter_campaigns
    FOR UPDATE
    USING (
        EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
    );

CREATE TRIGGER set_campaigns_updated_at
    BEFORE UPDATE ON public.newsletter_campaigns
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at();

-- ============================================================
-- 9. Seeder: Beispiel-Daten für den Schnellstart
-- ============================================================

-- Kategorien
INSERT INTO public.categories (name, slug, description, sort_order) VALUES
    ('Pizza Klassisch', 'pizza-klassisch', 'Unsere klassischen Pizzen – einfach und lecker', 1),
    ('Pizza Spezial', 'pizza-spezial', 'Unsere Spezialitäten mit besonderen Zutaten', 2),
    ('Pasta', 'pasta', 'Italienische Pastagerichte', 3),
    ('Salate', 'salate', 'Frische Salate', 4),
    ('Getränke', 'getraenke', 'Erfrischende Getränke', 5),
    ('Beilagen', 'beilagen', 'Passende Beilagen zur Pizza', 6)
ON CONFLICT (slug) DO NOTHING;

-- Beispiel-Produkte
INSERT INTO public.products (name, slug, description, price, category_id, is_featured, sort_order) VALUES
    ('Pizza Margherita', 'pizza-margherita', 'Tomatensauce, Mozzarella, Basilikum', 4.50, 1, TRUE, 1),
    ('Pizza Salami', 'pizza-salami', 'Tomatensauce, Mozzarella, Salami', 5.50, 1, TRUE, 2),
    ('Pizza Funghi', 'pizza-funghi', 'Tomatensauce, Mozzarella, frische Champignons', 5.50, 1, FALSE, 3),
    ('Pizza Prosciutto', 'pizza-prosciutto', 'Tomatensauce, Mozzarella, Kochschinken', 5.50, 1, FALSE, 4),
    ('Pizza Pepe', 'pizza-pepe', 'Tomatensauce, Mozzarella, Salami, Peperoni', 6.50, 2, TRUE, 5),
    ('Pizza Urinal', 'pizza-urinal', 'Sahnesauce, Mozzarella, Gorgonzola, Parmesan, Ziegenkäse', 7.50, 2, TRUE, 6),
    ('Pizza Calzone', 'pizza-calzone', 'Gefüllte Pizza mit Tomatensauce, Mozzarella, Schinken und Pilzen', 7.00, 2, FALSE, 7),
    ('Spaghetti Bolognese', 'spaghetti-bolognese', 'Spaghetti mit hausgemachter Fleischsauce', 6.50, 3, TRUE, 8),
    ('Penne Arrabbiata', 'penne-arrabbiata', 'Penne in scharfer Tomatensauce mit Knoblauch und Chili', 5.50, 3, FALSE, 9),
    ('Insalata Mista', 'insalata-mista', 'Gemischter Salat mit Tomaten, Gurken und Dressing', 4.00, 4, FALSE, 10),
    ('Cola 0,5l', 'cola-05l', 'Eisgekühlte Coca-Cola', 2.50, 5, FALSE, 11),
    ('Fanta 0,5l', 'fanta-05l', 'Eisgekühlte Fanta', 2.50, 5, FALSE, 12),
    ('Wasser 0,5l', 'wasser-05l', 'Eisgekühltes Mineralwasser', 2.00, 5, FALSE, 13),
    ('Knoblauchbrot', 'knoblauchbrot', 'Knuspriges Knoblauchbrot mit Kräuterbutter', 2.50, 6, FALSE, 14),
    ('Pommes', 'pommes', 'Knusprige Pommes Frites mit Mayo oder Ketchup', 3.00, 6, FALSE, 15)
ON CONFLICT (slug) DO NOTHING;