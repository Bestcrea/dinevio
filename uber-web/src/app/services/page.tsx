import Image from "next/image";
import Link from "next/link";

export default function ServicesPage() {
  return (
    <div className="min-h-screen bg-white text-black">
      <header className="w-full bg-black px-6 py-4 text-white">
        <div className="mx-auto flex max-w-6xl items-center justify-between">
          <Link href="/" className="text-xl font-black">
            Dinevio
          </Link>
          <div className="flex items-center gap-3 text-sm font-semibold">
            <Link href="/login" className="rounded-full px-4 py-2 hover:bg-white/10">
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

      <main className="mx-auto flex max-w-6xl flex-col gap-16 px-6 pb-20 pt-12 md:px-10 lg:px-0">
        <HeroSection />
        <ApplicationsSection />
        <OptionsSection />
      </main>
    </div>
  );
}

function HeroSection() {
  return (
    <section className="flex flex-col gap-6">
      <h1 className="text-5xl font-black leading-tight md:text-6xl">
        La technologie de Dinevio au service de tous
      </h1>
      <p className="text-lg text-gray-700 md:max-w-3xl">
        Changer la manière dont les utilisateurs commandent une course pour se déplacer n&apos;est
        qu&apos;un début.
      </p>
      <Link
        href="#"
        className="w-fit rounded-full bg-black px-6 py-3 text-base font-semibold text-white transition hover:bg-gray-900"
      >
        Découvrez l&apos;application
      </Link>
    </section>
  );
}

function ApplicationsSection() {
  return (
    <section className="grid gap-8 md:grid-cols-2 md:gap-12">
      <div className="flex flex-col gap-3">
        <h2 className="text-3xl font-black">
          Applications, produits et autres services Dinevio
        </h2>
        <p className="text-base leading-7 text-gray-700">
          Dinevio est une entreprise technologique dont la mission est d&apos;améliorer les
          déplacements dans le monde entier. Notre technologie nous aide à développer et à assurer
          le fonctionnement de plateformes polyvalentes qui permettent aux utilisateurs de chercher
          des courses et des prestataires indépendants proposant des courses, ainsi que d&apos;autres
          moyens de transport, y compris les transports en commun, vélos et trottinettes.
        </p>
      </div>
      <div className="flex flex-col gap-3">
        <p className="text-base leading-7 text-gray-700">
          Nous mettons également en relation les consommateurs et les restaurants, magasins
          d&apos;alimentation et autres commerçants afin qu&apos;ils puissent acheter et vendre des repas,
          des produits d&apos;épicerie et d&apos;autres articles, puis nous leur proposons de faire appel à
          des prestataires de services de livraison indépendants. De plus, Dinevio met en relation
          les expéditeurs et les sociétés de transport du secteur du fret.
        </p>
        <p className="text-base leading-7 text-gray-700">
          Notre technologie permet aux gens de se connecter et de se déplacer dans plus de 70 pays
          et plus de 15 000 villes à travers le monde.
        </p>
      </div>
    </section>
  );
}

function OptionsSection() {
  const options = [
    {
      title: "Dinevio X",
      description: "Des courses abordables, rien que pour vous",
      image: "/assets/services_site/dineviox.png",
    },
    {
      title: "Dinevio Share",
      description: "Partagez la course avec un seul passager",
      image: "/assets/services_site/dinevio_share.png",
    },
    {
      title: "Dinevio Comfort",
      description: "Des voitures récentes et spacieuses",
      image: "/assets/services_site/dinevio_comfort.png",
    },
  ];

  return (
    <section className="flex flex-col gap-8">
      <div className="flex flex-col gap-3">
        <h2 className="text-4xl font-black leading-tight md:text-5xl">
          Les options de courses Dinevio les plus populaires
        </h2>
        <p className="text-lg text-gray-700">
          Commandez une course, montez à bord et c&apos;est parti.
        </p>
        <div className="flex flex-wrap gap-4 text-sm font-semibold">
          <Link className="underline" href="#">
            Téléchargez l&apos;application
          </Link>
          <Link className="underline" href="#">
            Voir plus d&apos;options de courses
          </Link>
        </div>
      </div>

      <div className="grid gap-6 md:grid-cols-3">
        {options.map((opt) => (
          <div
            key={opt.title}
            className="flex flex-col gap-4 rounded-2xl border border-gray-200 bg-white p-4 shadow-sm"
          >
            <div className="relative h-40 w-full">
              <Image src={opt.image} alt={opt.title} fill className="object-contain" />
            </div>
            <div className="flex flex-col gap-2">
              <h3 className="text-xl font-bold">{opt.title}</h3>
              <p className="text-sm text-gray-700">{opt.description}</p>
              <Link className="text-sm font-semibold underline" href="#">
                En savoir plus
              </Link>
            </div>
          </div>
        ))}
      </div>
    </section>
  );
}







