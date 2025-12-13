import Link from "next/link";

export default function LangPage() {
  const langs = [
    { label: "English", code: "en" },
    { label: "العربية", code: "ar" },
    { label: "Français (France)", code: "fr" },
  ];

  return (
    <div className="min-h-screen bg-white text-black">
      <header className="border-b border-gray-100">
        <div className="mx-auto flex max-w-6xl items-center justify-start gap-3 px-6 py-4 md:px-10 lg:px-0">
          <Link
            href="/"
            className="rounded-full bg-gray-100 px-3 py-1 text-xs font-semibold text-gray-700 transition hover:bg-gray-200"
          >
            ← Retour
          </Link>
          <p className="text-sm font-semibold text-gray-900">
            Sélectionnez votre langue préférée
          </p>
        </div>
      </header>

      <main className="mx-auto flex max-w-5xl flex-col items-center gap-12 px-6 py-14 md:px-10 lg:px-0">
        <h1 className="text-3xl font-black text-center md:text-4xl">
          Sélectionnez votre langue préférée
        </h1>
        <div className="grid w-full gap-6 md:grid-cols-3">
          {langs.map((lang) => (
            <button
              key={lang.code}
              className="flex items-center justify-center rounded-2xl border border-gray-200 bg-gray-50 px-6 py-8 text-lg font-semibold text-gray-900 shadow-sm transition hover:border-gray-300 hover:bg-white"
              type="button"
            >
              {lang.label}
            </button>
          ))}
        </div>
      </main>
    </div>
  );
}

