"use client";

import { useState } from "react";
import Image from "next/image";
import Link from "next/link";

const navLinks = [
  { label: "Accueil", href: "/" },
  { label: "Nos services", href: "/services" },
  { label: "Déplacez-vous avec nous", href: "/services" },
  { label: "Drive", href: "/drive" },
  { label: "Dinevio Eats", href: "/eats" },
  { label: "Aide", href: "/help" },
  { label: "Connexion", href: "/login" },
  { label: "S’inscrire", href: "/signup" },
];

export function Header() {
  const [open, setOpen] = useState(false);

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
            {navLinks.slice(1, 5).map((item) => (
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

        <div className="ml-auto hidden items-center gap-4 text-sm font-medium md:flex">
          <Link
            href="/lang"
            className="rounded-full bg-white/10 px-4 py-2 transition hover:bg-white/15"
          >
            FR-FR
          </Link>
          <Link
            href="/help"
            className="rounded-full px-4 py-2 transition hover:bg-white/10"
          >
            Aide
          </Link>
          <Link
            href="/login"
            className="rounded-full px-4 py-2 transition hover:bg-white/10"
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

        <button
          onClick={() => setOpen(true)}
          className="ml-auto rounded-full bg-white/10 px-3 py-2 text-sm font-semibold md:hidden"
          aria-label="Ouvrir le menu"
        >
          ☰
        </button>
      </div>

      {open && (
        <div className="md:hidden">
          <div className="fixed inset-0 bg-black/60" onClick={() => setOpen(false)} />
          <div className="fixed right-0 top-0 h-full w-72 bg-black text-white shadow-2xl">
            <div className="flex items-center justify-between px-4 py-4 border-b border-white/10">
              <span className="text-sm font-semibold">Menu</span>
              <button
                onClick={() => setOpen(false)}
                className="rounded-full bg-white/10 px-3 py-1 text-sm"
                aria-label="Fermer le menu"
              >
                ✕
              </button>
            </div>
            <nav className="flex flex-col divide-y divide-white/10">
              {navLinks.map((item) => (
                <Link
                  key={item.label}
                  href={item.href}
                  className="px-4 py-3 text-sm font-semibold transition hover:bg-white/10"
                  onClick={() => setOpen(false)}
                >
                  {item.label}
                </Link>
              ))}
            </nav>
          </div>
        </div>
      )}
    </header>
  );
}






