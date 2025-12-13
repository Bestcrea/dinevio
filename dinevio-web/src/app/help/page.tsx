import Image from "next/image";
import Link from "next/link";
import { Header } from "../_components/Header";

export default function HelpPage() {
  const categories = [
    { title: "Riders", kind: "car" },
    { title: "Driving & Delivering", kind: "steering" },
    { title: "Dinevio Eats", kind: "cutlery" },
    { title: "Merchants & Restaurants", kind: "store" },
    { title: "Bikes & Scooters", kind: "scooter" },
    { title: "Dinevio for Business", kind: "briefcase" },
    { title: "Freight", kind: "truck" },
  ];

  return (
    <div className="bg-white text-black">
      <Header />
      <header className="border-b border-gray-100 bg-white">
        <div className="mx-auto flex max-w-6xl items-center gap-4 px-6 py-4 md:px-10 lg:px-0">
          <Link
            href="/"
            className="rounded-full bg-gray-100 px-3 py-1 text-xs font-semibold text-gray-700 transition hover:bg-gray-200"
          >
            ← Retour
          </Link>
          <p className="text-sm font-semibold text-gray-900">Help</p>
        </div>
      </header>

      <main className="mx-auto flex max-w-6xl flex-col gap-10 px-6 py-12 md:px-10 lg:px-0">
        <section className="flex flex-col gap-4 text-center">
          <h1 className="text-4xl font-black md:text-5xl">
            Welcome to Dinevio Support
          </h1>
          <p className="text-base text-gray-600 md:text-lg">
            We&apos;re here to help. Looking for customer service contact
            information? Explore support resources for the relevant products
            below to find the best way to reach out about your issue.
          </p>
        </section>

        <section className="grid gap-4 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4">
          {categories.map((cat) => (
            <div
              key={cat.title}
              className="flex flex-col items-center justify-center gap-3 rounded-2xl border border-gray-200 bg-gray-50 px-4 py-6 text-center shadow-sm transition hover:border-gray-300 hover:bg-white"
            >
              <CategoryIcon kind={cat.kind} />
              <p className="text-sm font-semibold text-gray-900">{cat.title}</p>
            </div>
          ))}
        </section>
      </main>
    </div>
  );
}

function CategoryIcon({ kind }: { kind: string }) {
  const common = "h-8 w-8 stroke-[1.6] text-gray-900";

  switch (kind) {
    case "car":
      return (
        <svg viewBox="0 0 24 24" className={common} fill="none" aria-hidden>
          <path
            d="M4 14h16l-1.2-4.5a2 2 0 0 0-1.93-1.5H7.13a2 2 0 0 0-1.93 1.5L4 14Zm0 0v3.5a.5.5 0 0 0 .5.5H6m12 0h1.5a.5.5 0 0 0 .5-.5V14m-14 4h12m-11-3h1m10 0h-1"
            stroke="currentColor"
            strokeLinecap="round"
            strokeLinejoin="round"
          />
        </svg>
      );
    case "steering":
      return (
        <svg viewBox="0 0 24 24" className={common} fill="none" aria-hidden>
          <circle cx="12" cy="12" r="7" stroke="currentColor" />
          <circle cx="12" cy="12" r="2" stroke="currentColor" />
          <path d="M5 13h4m6 0h4m-9 6v-4" stroke="currentColor" strokeLinecap="round" />
        </svg>
      );
    case "cutlery":
      return (
        <svg viewBox="0 0 24 24" className={common} fill="none" aria-hidden>
          <path
            d="M7 3v6m0 0-2 1.5M7 9l2 1.5M17 4.5c0 1.5-2 2-2 4.5V21m-8 0V12"
            stroke="currentColor"
            strokeLinecap="round"
            strokeLinejoin="round"
          />
        </svg>
      );
    case "store":
      return (
        <svg viewBox="0 0 24 24" className={common} fill="none" aria-hidden>
          <path
            d="M4 10h16l-1-5H5l-1 5Zm0 0v9h16v-9M9 14h6m-3 0v5"
            stroke="currentColor"
            strokeLinecap="round"
            strokeLinejoin="round"
          />
        </svg>
      );
    case "scooter":
      return (
        <svg viewBox="0 0 24 24" className={common} fill="none" aria-hidden>
          <circle cx="7" cy="17" r="2.5" stroke="currentColor" />
          <circle cx="17" cy="17" r="2.5" stroke="currentColor" />
          <path
            d="M7 17h7l-2.5-8H11m5-4h-2l1.5 5H19"
            stroke="currentColor"
            strokeLinecap="round"
            strokeLinejoin="round"
          />
        </svg>
      );
    case "briefcase":
      return (
        <svg viewBox="0 0 24 24" className={common} fill="none" aria-hidden>
          <path
            d="M8 7V6a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v1m-8 0h8m-8 0H5a2 2 0 0 0-2 2v8a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-8a2 2 0 0 0-2-2h-3m-4 5h2"
            stroke="currentColor"
            strokeLinecap="round"
            strokeLinejoin="round"
          />
        </svg>
      );
    case "truck":
      return (
        <svg viewBox="0 0 24 24" className={common} fill="none" aria-hidden>
          <path
            d="M3 6h12v9H3V6Zm12 4h3l3 3v2h-6M6.5 18a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3Zm9 0a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3Z"
            stroke="currentColor"
            strokeLinecap="round"
            strokeLinejoin="round"
          />
        </svg>
      );
    default:
      return null;
  }
}

// Footer aligné comme la home
// --------------------------------------------------
// Réutilisation inline du footer pour cette page
export function Footer() {
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

