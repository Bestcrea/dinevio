import Image from "next/image";
import Link from "next/link";

export default function SignupPage() {
  return (
    <div className="min-h-screen bg-white text-black">
      <header className="w-full bg-black px-6 py-4 text-white">
        <div className="mx-auto flex max-w-6xl items-center justify-between">
          <Link href="/" aria-label="Accueil Dinevio" className="flex items-center gap-3">
            <Image
              src="/assets/logo_web.png"
              alt="Dinevio"
              width={80}
              height={32}
              className="h-8 w-auto"
              priority
            />
          </Link>
          <div className="flex items-center gap-3 text-sm font-semibold">
            <Link href="/" className="rounded-full px-4 py-2 hover:bg-white/10">
              Accueil
            </Link>
            <Link
              href="/login"
              className="rounded-full bg-white px-4 py-2 text-black transition hover:bg-gray-100"
            >
              Connexion
            </Link>
          </div>
        </div>
      </header>

      <main className="mx-auto flex max-w-xl flex-col gap-6 px-6 pb-16 pt-12 text-center">
        <h1 className="text-3xl font-black leading-tight">
          Créez votre compte Dinevio
        </h1>

        <input
          type="text"
          placeholder="Saisissez un numéro de téléphone ou une adresse e-mail"
          className="w-full rounded-lg border border-gray-200 px-4 py-3 text-base shadow-sm focus:border-black focus:outline-none"
        />

        <button className="w-full rounded-lg bg-black px-4 py-3 text-base font-semibold text-white transition hover:bg-gray-900">
          Continuer
        </button>

        <Divider label="ou" />

        <SocialButton label="Continuer avec Google" />
        <SocialButton label="Continuer avec Apple" />

        <Divider label="ou" />

        <button className="w-full rounded-lg border border-gray-300 px-4 py-3 text-base font-semibold text-gray-800 transition hover:border-gray-400">
          Connectez-vous avec le QR code
        </button>

        <p className="mt-6 text-xs leading-5 text-gray-600">
          En continuant, vous acceptez de recevoir des appels, y compris par
          numérotation automatique, des communications sur WhatsApp ou des SMS
          de Dinevio ou de ses sociétés affiliées.
        </p>
      </main>
    </div>
  );
}

function Divider({ label }: { label: string }) {
  return (
    <div className="flex items-center gap-3 text-sm font-semibold text-gray-500">
      <span className="h-px flex-1 bg-gray-200" />
      {label}
      <span className="h-px flex-1 bg-gray-200" />
    </div>
  );
}

function SocialButton({ label }: { label: string }) {
  return (
    <button className="w-full rounded-lg bg-gray-100 px-4 py-3 text-base font-semibold text-gray-900 transition hover:bg-gray-200">
      {label}
    </button>
  );
}


