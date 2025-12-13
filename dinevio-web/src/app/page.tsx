import Image from "next/image";
import Link from "next/link";
import { Header } from "./_components/Header";

const suggestions = [
  {
    title: "Ride",
    lines: [
      "Il vous suffit de vous connecter à votre compte.",
      "Commandez une course en un clic.",
    ],
    image: "/assets/suggestions/suggestion1.png",
  },
  {
    title: "Reserve",
    lines: [
      "Réservez votre course à l'avance",
      "Vous trouverez votre date.",
    ],
    image: "/assets/suggestions/suggestion2.png",
  },
];

export default function Home() {
  return (
    <div className="min-h-screen bg-white text-black">
      <Header />
      <main className="mx-auto flex max-w-6xl flex-col gap-16 px-6 pb-20 pt-10 md:px-10 lg:px-0">
        <Hero />
        <Suggestions />
        <AccountBlock />
        <DriverBlock />
        <DownloadBlock />
      </main>
      <Footer />
    </div>
  );
}

function Hero() {
  return (
    <section className="grid gap-10 lg:grid-cols-2 lg:items-center">
      <div className="flex flex-col gap-6">
        <div className="flex items-center gap-2 text-sm font-semibold text-gray-700">
          <span className="text-lg" aria-hidden>
            📍
          </span>
          <span>Rabat, MA</span>
          <a className="text-base font-semibold underline" href="#">
            Changer de ville
          </a>
        </div>
        <h1 className="text-4xl font-black leading-tight md:text-5xl">
          Allez où vous voulez avec Dinevio
        </h1>

        <div className="flex flex-col gap-3 rounded-2xl bg-gray-50 p-4 shadow-sm ring-1 ring-gray-200">
          <button className="flex w-full items-center justify-between rounded-lg bg-white px-4 py-3 text-left text-base font-semibold shadow-sm ring-1 ring-gray-200 transition hover:ring-gray-300">
            <span className="flex items-center gap-3">
              Prendre en charge maintenant
            </span>
            <span aria-hidden>▾</span>
          </button>

          <div className="flex flex-col gap-2">
            <InputRow placeholder="Lieu de prise en charge" ctaIcon="➤" />
            <InputRow placeholder="Destination" />
          </div>

          <button className="mt-2 h-12 rounded-lg bg-black text-base font-semibold text-white transition hover:bg-gray-900">
            Voir les prix
          </button>
          <p className="text-sm text-gray-600">
            Connectez-vous pour consulter votre activité récente
          </p>
        </div>
      </div>

      <div className="relative">
        <div className="overflow-hidden rounded-2xl shadow-lg ring-1 ring-gray-200">
          <Image
            src="/assets/illustration_web1.jpg"
            alt="Illustration voyage"
            width={900}
            height={700}
            className="h-full w-full object-cover"
            priority
          />
        </div>
        <div className="absolute inset-x-6 -bottom-6 hidden rounded-2xl bg-white/95 px-6 py-4 shadow-xl ring-1 ring-gray-200 lg:block">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-semibold text-gray-700">
                Prêt à voyager ?
              </p>
              <p className="text-sm text-gray-500">
                Planifiez en avance et partez sereinement.
              </p>
            </div>
            <button className="rounded-full bg-black px-4 py-2 text-sm font-semibold text-white transition hover:bg-gray-900">
              Planifiez à l&apos;avance
            </button>
          </div>
        </div>
      </div>
    </section>
  );
}

function InputRow({
  placeholder,
  ctaIcon,
}: {
  placeholder: string;
  ctaIcon?: string;
}) {
  return (
    <div className="flex items-center gap-3 rounded-lg bg-white px-4 py-3 shadow-sm ring-1 ring-gray-200 transition hover:ring-gray-300">
      <input
        aria-label={placeholder}
        placeholder={placeholder}
        className="w-full text-base placeholder:text-gray-500 focus:outline-none"
      />
      {ctaIcon ? (
        <span className="text-lg text-gray-500" aria-hidden>
          {ctaIcon}
        </span>
      ) : null}
    </div>
  );
}

function Suggestions() {
  return (
    <section className="flex flex-col gap-6">
      <h2 className="text-3xl font-black">Suggestions</h2>
      <div className="grid gap-4 md:grid-cols-2">
        {suggestions.map((item) => (
          <div
            key={item.title}
            className="flex flex-col gap-4 rounded-2xl bg-gray-100 p-6 shadow-sm ring-1 ring-gray-200 md:flex-row md:items-center md:justify-between"
          >
            <div className="flex flex-col gap-2">
              <p className="text-lg font-bold text-gray-900">{item.title}</p>
              {item.lines.map((line) => (
                <p key={line} className="text-sm text-gray-600">
                  {line}
                </p>
              ))}
            </div>
            <div className="flex items-center gap-4 md:flex-col md:items-end md:gap-3">
              <Image
                src={item.image}
                alt={item.title}
                width={140}
                height={100}
                className="h-20 w-auto object-contain"
              />
              <button className="w-fit rounded-full bg-white px-4 py-2 text-sm font-semibold text-black shadow-sm ring-1 ring-gray-200 transition hover:ring-gray-300">
                Détails
              </button>
            </div>
          </div>
        ))}
      </div>
    </section>
  );
}

function AccountBlock() {
  return (
    <section className="grid gap-8 rounded-3xl bg-white px-4 py-8 ring-1 ring-gray-200 md:grid-cols-2 md:items-center md:px-10">
      <div className="flex flex-col gap-4">
        <h3 className="text-3xl font-black leading-tight">
          Connectez-vous pour consulter les détails de votre compte
        </h3>
        <p className="text-base text-gray-600">
          Consultez les trajets passés, les suggestions personnalisées, les
          ressources d&apos;aide et plus encore.
        </p>
        <div className="flex flex-col gap-3 sm:flex-row">
          <button className="rounded-lg bg-black px-5 py-3 text-sm font-semibold text-white transition hover:bg-gray-900">
            Connectez-vous à votre compte
          </button>
          <button className="rounded-lg px-5 py-3 text-sm font-semibold underline transition hover:text-gray-700">
            Créez un compte.
          </button>
        </div>
      </div>
      <div className="overflow-hidden rounded-2xl bg-gray-50 ring-1 ring-gray-200">
        <Image
          src="/assets/illustration_web2.jpg"
          alt="Illustration compte"
          width={800}
          height={600}
          className="h-full w-full object-cover"
        />
      </div>
    </section>
  );
}

function DriverBlock() {
  return (
    <section className="grid gap-8 rounded-3xl bg-white px-4 py-8 ring-1 ring-gray-200 md:grid-cols-2 md:items-center md:px-10">
      <div className="overflow-hidden rounded-2xl bg-gray-50 ring-1 ring-gray-200">
        <Image
          src="/assets/illustration_web3.jpg"
          alt="Illustration conducteur"
          width={900}
          height={700}
          className="h-full w-full object-cover"
        />
      </div>
      <div className="flex flex-col gap-4">
        <h3 className="text-3xl font-black leading-tight">
          Conduisez quand vous voulez, générez des revenus sur mesure
        </h3>
        <p className="text-base text-gray-600">
          Générez des revenus selon votre emploi du temps en effectuant des
          livraisons ou des courses. Utilisez votre propre véhicule ou une
          voiture de location.
        </p>
        <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
          <button className="rounded-lg bg-black px-5 py-3 text-sm font-semibold text-white transition hover:bg-gray-900">
            Commencez
          </button>
          <button className="text-sm font-semibold underline transition hover:text-gray-700">
            Vous avez déjà un compte ? Connectez-vous
          </button>
        </div>
      </div>
    </section>
  );
}

function DownloadBlock() {
  return (
    <section className="flex flex-col gap-6 rounded-3xl bg-gray-50 px-4 py-10 ring-1 ring-gray-200 md:px-10">
      <h3 className="text-3xl font-black">C&apos;est plus simple dans les applications</h3>
      <div className="grid gap-4 md:grid-cols-2">
        <DownloadCard
          title="Téléchargez l'application Dinevio"
          subtitle="Scannez pour télécharger"
        />
        <DownloadCard
          title="Téléchargez l'application pour les chauffeurs et les coursiers Dinevio"
          subtitle="Scannez pour télécharger"
        />
      </div>
    </section>
  );
}

function DownloadCard({ title, subtitle }: { title: string; subtitle: string }) {
  return (
    <div className="flex flex-col gap-4 rounded-2xl bg-white p-6 shadow-sm ring-1 ring-gray-200">
      <div className="flex items-center gap-4">
        <div className="flex h-28 w-28 items-center justify-center rounded-xl bg-gray-100 text-xs font-semibold text-gray-500 ring-1 ring-gray-200">
          QR
        </div>
        <div className="flex flex-col gap-1">
          <p className="text-xl font-bold">{title}</p>
          <p className="text-sm text-gray-600">{subtitle}</p>
        </div>
      </div>
      <button className="w-fit text-sm font-semibold underline transition hover:text-gray-700">
        Télécharger
      </button>
    </div>
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

        <div className="flex flex-col gap-4 border-t border-white/10 pt-6 md:flex-row md:items-center md:justify-between">
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
    case "linkedin":
      return null;
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
