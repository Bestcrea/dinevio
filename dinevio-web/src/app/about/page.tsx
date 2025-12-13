import Image from "next/image";
import Link from "next/link";
import { Header } from "../_components/Header";

export default function AboutPage() {
  return (
    <div className="bg-white text-black">
      <Header />
      <section className="relative h-[520px] w-full overflow-hidden">
        <Image
          src="/assets/about_us/about_us.jpg"
          alt="À propos Dinevio"
          fill
          className="object-cover"
          priority
        />
        <div className="absolute inset-x-0 bottom-0 bg-gradient-to-t from-black/50 to-transparent px-6 pb-10 pt-24 md:px-10 lg:px-16">
          <h1 className="text-4xl font-black text-white md:text-5xl">À propos</h1>
        </div>
      </section>

      <main className="mx-auto flex max-w-6xl flex-col gap-10 px-6 py-12 md:px-10 lg:px-0">
        <section className="flex flex-col gap-4">
          <h2 className="text-4xl font-black leading-tight md:text-5xl">
            La technologie de Dinevio au service de tous
          </h2>
          <p className="text-lg text-gray-700">
            Changer la manière dont les utilisateurs commandent une course pour se déplacer
            n&apos;est qu&apos;un début.
          </p>
          <button className="mt-2 w-fit rounded-full bg-black px-6 py-3 text-base font-semibold text-white transition hover:bg-gray-900">
            Découvrez l&apos;application
          </button>
        </section>

        <section className="grid gap-10 md:grid-cols-2 md:gap-14">
          <div className="flex flex-col gap-4 text-base leading-7 text-gray-700">
            <h3 className="text-3xl font-black">
              Applications, produits et autres services Dinevio
            </h3>
            <p>
              Dinevio est une entreprise technologique dont la mission est d&apos;améliorer
              les déplacements dans le monde entier. Notre technologie nous aide à
              développer et à assurer le fonctionnement de plateformes polyvalentes qui
              permettent aux utilisateurs de chercher des courses et des prestataires
              indépendants proposant des courses, ainsi que d&apos;autres moyens de transport,
              y compris les transports en commun, vélos et trottinettes.
            </p>
          </div>
          <div className="flex flex-col gap-4 text-base leading-7 text-gray-700">
            <p>
              Nous mettons également en relation les consommateurs et les restaurants,
              magasins d&apos;alimentation et autres commerçants afin qu&apos;ils puissent acheter
              et vendre des repas, des produits d&apos;épicerie et d&apos;autres articles, puis nous
              leur proposons de faire appel à des prestataires de services de livraison
              indépendants. De plus, Dinevio met en relation les expéditeurs et les sociétés
              de transport du secteur du fret.
            </p>
            <p>
              Notre technologie permet aux gens de se connecter et de se déplacer dans plus
              de 70 pays et plus de 15 000 villes à travers le monde.
            </p>
          </div>
        </section>
      </main>
      <Footer />
    </div>
  );
}

function Header() {
  return (
    <header className="w-full bg-black text-white">
      <div className="mx-auto flex max-w-6xl items-center gap-6 px-6 py-4 md:px-10 lg:px-0">
        <div className="flex items-center gap-10">
          <Link href="/">
            <Image
              src="/assets/logo_web.png"
              alt="Dinevio"
              width={80}
              height={32}
              className="h-8 w-auto"
              priority
            />
          </Link>
          <nav className="hidden items-center gap-6 text-sm font-medium md:flex">
            {navItems.map((item) => (
              <Link
                key={item.label}
                className="transition hover:text-gray-200"
                href={item.href}
              >
                {item.label}
              </Link>
            ))}
          </nav>
        </div>

        <div className="ml-auto flex items-center gap-4 text-sm font-medium">
          <Link
            href="/lang"
            className="rounded-full bg-white/10 px-4 py-2 transition hover:bg-white/15"
          >
            FR-FR
          </Link>
          <Link
            href="/help"
            className="hidden rounded-full px-4 py-2 transition hover:bg-white/10 md:block"
          >
            Aide
          </Link>
          <Link
            href="/login"
            className="hidden rounded-full px-4 py-2 transition hover:bg-white/10 md:block"
          >
            Connexion
          </Link>
          <Link
            href="/signup"
            className="rounded-full bg-white px-4 py-2 text-black transition hover:bg-gray-100"
          >
            S&apos;inscrire
          </Link>
        </div>
      </div>
    </header>
  );
}

function Footer() {
  const columns = [
    {
      title: "Company",
      items: [
        { label: "About us", href: "#" },
        { label: "Our offerings", href: "/services" },
        { label: "Newsroom", href: "#" },
        { label: "Investors", href: "#" },
        { label: "Blog", href: "#" },
        { label: "Careers", href: "#" },
      ],
    },
    {
      title: "Products",
      items: [
        { label: "Ride", href: "/services" },
        { label: "Drive", href: "/drive" },
        { label: "Eat", href: "/eats" },
        { label: "Dinevio Freight", href: "#" },
        { label: "Gift cards", href: "#" },
        { label: "Dinevio Health", href: "#" },
      ],
    },
    {
      title: "Global citizenship",
      items: [
        { label: "Safety", href: "#" },
        { label: "Sustainability", href: "#" },
      ],
    },
    {
      title: "Travel",
      items: [
        { label: "Reserve", href: "#" },
        { label: "Airports", href: "#" },
        { label: "Cities", href: "#" },
      ],
    },
  ];

  const socials = [
    {
      key: "facebook",
      href: "https://www.facebook.com/share/17wuGVvjeu/?mibextid=wwXIfr",
      title: "Facebook",
    },
    { key: "youtube", href: "#", title: "YouTube" },
    {
      key: "instagram",
      href: "https://www.instagram.com/dinevioapp?igsh=cnQ1dnFzNmEzcXdm&utm_source=qr",
      title: "Instagram",
    },
    { key: "x", href: "#", title: "Twitter / X" },
  ];

  return (
    <footer className="mt-6 w-full bg-black text-white">
      <div className="mx-auto flex w-full max-w-none flex-col gap-10 px-6 py-10 md:px-10 lg:px-12">
        <div className="grid gap-8 sm:grid-cols-2 lg:grid-cols-4">
          {columns.map((col) => (
            <div key={col.title} className="flex flex-col gap-3">
              <h4 className="text-lg font-bold">{col.title}</h4>
              <ul className="flex flex-col gap-2 text-sm text-gray-200">
                {col.items.map((item) => (
                  <li key={item.label}>
                    <Link
                      href={item.href}
                      className="transition hover:text-white"
                    >
                      {item.label}
                    </Link>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>

        <div className="flex flex-col gap-4 border-top border-white/10 pt-6 md:flex-row md:items-center md:justify-between">
          <div className="flex items-center gap-4 text-sm font-semibold text-gray-200 md:order-2">
            {socials.map((s) => (
              <Link
                key={s.key}
                href={s.href}
                aria-label={s.title}
                className="flex h-9 w-9 items-center justify-center rounded-full bg-white/10 transition hover:bg-white/20"
              >
                <SocialIcon kind={s.key} />
              </Link>
            ))}
          </div>
          <div className="flex flex-wrap items-center gap-6 text-sm font-semibold text-gray-200 md:justify-end">
            <Link href="#" className="transition hover:text-white">
              Français (France)
            </Link>
            <div className="flex items-center gap-2">
              <span className="inline-block h-2 w-2 rounded-full bg-white" aria-hidden />
              <span>Rabat</span>
            </div>
          </div>
          <div className="text-xs text-gray-400 md:order-1 md:text-sm">
            © 2025 Dinevio LLC.
          </div>
        </div>
      </div>
    </footer>
  );
}

function SocialIcon({ kind }: { kind: string }) {
  const common = "h-5 w-5 fill-white";

  switch (kind) {
    case "facebook":
      return (
        <svg viewBox="0 0 24 24" className={common} aria-hidden>
          <path d="M22.675 0H1.325C.593 0 0 .593 0 1.325v21.35C0 23.406.593 24 1.325 24H12.82V14.706h-3.1v-3.6h3.1V8.413c0-3.066 1.873-4.735 4.61-4.735 1.312 0 2.44.098 2.767.142v3.21l-1.9.001c-1.491 0-1.78.71-1.78 1.75v2.295h3.56l-.463 3.6h-3.097V24h6.075C23.406 24 24 23.406 24 22.675V1.325C24 .593 23.406 0 22.675 0z" />
        </svg>
      );
    case "youtube":
      return (
        <svg viewBox="0 0 24 24" className={common} aria-hidden>
          <path d="M23.5 6.2a3 3 0 0 0-2.1-2.1C19.5 3.6 12 3.6 12 3.6s-7.5 0-9.4.5A3 3 0 0 0 .5 6.2 31.2 31.2 0 0 0 0 12a31.2 31.2 0 0 0 .5 5.8 3 3 0 0 0 2.1 2.1c1.9.5 9.4.5 9.4.5s7.5 0 9.4-.5a3 3 0 0 0 2.1-2.1A31.2 31.2 0 0 0 24 12a31.2 31.2 0 0 0-.5-5.8zM9.6 15.6V8.4l6.3 3.6z" />
        </svg>
      );
    case "instagram":
      return (
        <svg viewBox="0 0 24 24" className={common} aria-hidden>
          <path d="M12 2.2c3.2 0 3.6 0 4.9.1 1.2.1 1.9.3 2.3.5.6.2 1 .6 1.5 1 .5.5.8.9 1 1.5.2.4.4 1.1.5 2.3.1 1.3.1 1.7.1 4.9s0 3.6-.1 4.9c-.1 1.2-.3 1.9-.5 2.3-.2.6-.6 1-1 1.5-.5.5-.9.8-1.5 1-.4.2-1.1.4-2.3.5-1.3.1-1.7.1-4.9.1s-3.6 0-4.9-.1c-1.2-.1-1.9-.3-2.3-.5a3.9 3.9 0 0 1-1.5-1c-.5-.5-.8-.9-1-1.5-.2-.4-.4-1.1-.5-2.3C2.2 15.6 2.2 15.2 2.2 12s0-3.6.1-4.9c.1-1.2.3-1.9.5-2.3.2-.6.6-1 1-1.5.5-.5.9-.8 1.5-1 .4-.2 1.1-.4 2.3-.5C8.4 2.2 8.8 2.2 12 2.2zm0-2.2C8.7 0 8.3 0 7 0 5.7 0 4.8.2 4 .5c-.9.3-1.7.8-2.4 1.5A6.4 6.4 0 0 0 .5 4C.2 4.8 0 5.7 0 7c0 1.3 0 1.7-.1 5 0 3.3 0 3.7.1 5 .1 1.3.3 2.2.6 3 .3.8.8 1.6 1.5 2.3a6.4 6.4 0 0 0 2.3 1.5c.8.3 1.7.5 3 .6 1.3.1 1.7.1 5 .1s3.7 0 5-.1c1.3-.1 2.2-.3 3-.6a6.4 6.4 0 0 0 2.3-1.5 6.4 6.4 0 0 0 1.5-2.3c.3-.8.5-1.7.6-3 .1-1.3.1-1.7.1-5s0-3.7-.1-5c-.1-1.3-.3-2.2-.6-3a6.4 6.4 0 0 0-1.5-2.3A6.4 6.4 0 0 0 20 .5c-.8-.3-1.7-.5-3-.6C15.7 0 15.3 0 12 0z" />
          <path d="M12 5.8A6.2 6.2 0 1 0 12 18.2 6.2 6.2 0 0 0 12 5.8zm0 10.2A4 4 0 1 1 12 8a4 4 0 0 1 0 8zm6.4-10.9a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0z" />
        </svg>
      );
    case "x":
    default:
      return (
        <svg viewBox="0 0 24 24" className={common} aria-hidden>
          <path d="M18.9 2H22l-7 7.9L23 22h-6.5l-5-6.6L5.8 22H2.6l7.5-8.5L1.8 2h6.7l4.5 5.9L18.9 2zm-1.1 18.1h1.8L7.3 3.8H5.4l12.4 16.3z" />
        </svg>
      );
  }
}

