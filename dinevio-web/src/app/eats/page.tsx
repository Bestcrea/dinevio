import Image from "next/image";
import Link from "next/link";

export default function EatsPage() {
  const cards = [
    {
      title: "Feed your employees",
      cta: "Create a business account",
      href: "#",
      image: "/assets/dinevio_eats/employee.jpg",
    },
    {
      title: "Your restaurant, delivered",
      cta: "Add your restaurant",
      href: "#",
      image: "/assets/dinevio_eats/restaurant_deliver.jpg",
    },
    {
      title: "Deliver with Dinevio",
      cta: "Sign up to deliver",
      href: "#",
      image: "/assets/dinevio_eats/deliver_with_dinevio.jpg",
    },
  ];

  return (
    <div className="min-h-screen bg-white text-black">
      <header className="absolute left-0 right-0 top-0 z-20">
        <div className="mx-auto flex max-w-6xl items-center justify-between px-6 py-6 md:px-10 lg:px-0">
          <Link href="/" className="text-lg font-black">
            Dinevio Eats
          </Link>
          <div className="flex items-center gap-3 text-sm font-semibold">
            <Link href="/services" className="rounded-full px-4 py-2 text-white transition hover:bg-white/10">
              Get a ride
            </Link>
            <Link href="/login" className="rounded-full bg-white px-4 py-2 text-black transition hover:bg-gray-100">
              Log in
            </Link>
            <Link
              href="/signup"
              className="rounded-full border border-white px-4 py-2 text-white transition hover:bg-white hover:text-black"
            >
              Sign up
            </Link>
          </div>
        </div>
      </header>

      <main className="flex flex-col gap-14 pb-16">
        <Hero />

        <section className="mx-auto grid max-w-6xl gap-6 px-6 md:px-10 lg:grid-cols-3 lg:px-0">
          {cards.map((card) => (
            <article
              key={card.title}
              className="overflow-hidden rounded-2xl border border-gray-200 bg-white shadow-sm"
            >
              <div className="relative h-56 w-full">
                <Image src={card.image} alt={card.title} fill className="object-cover" />
              </div>
              <div className="flex flex-col gap-2 p-5">
                <h3 className="text-xl font-bold">{card.title}</h3>
                <Link href={card.href} className="text-sm font-semibold underline">
                  {card.cta}
                </Link>
              </div>
            </article>
          ))}
        </section>
      </main>
    </div>
  );
}

function Hero() {
  return (
    <section
      className="relative flex min-h-[520px] items-center bg-cover bg-center"
      style={{ backgroundImage: "url('/assets/dinevio_eats/banner.jpg')" }}
    >
      <div className="absolute inset-0 bg-black/50" />
      <div className="relative z-10 mx-auto flex w-full max-w-6xl flex-col gap-6 px-6 md:px-10 lg:px-0">
        <div className="flex items-center justify-start">
          <div className="flex items-center gap-2 rounded-full bg-white/10 px-3 py-2 text-sm font-semibold text-white backdrop-blur">
            <span role="img" aria-label="burger">
              🍔
            </span>
            <span>Dinevio Eats</span>
          </div>
        </div>

        <div className="flex flex-col gap-4 text-white">
          <h1 className="text-4xl font-black leading-tight md:text-5xl lg:text-6xl">
            Order delivery near you
          </h1>
          <div className="flex flex-col gap-3 text-base font-semibold md:flex-row md:items-center">
            <input
              type="text"
              placeholder="Enter delivery address"
              className="h-12 w-full rounded-full border border-white/30 bg-white/90 px-4 text-black placeholder:text-gray-500 focus:outline-none focus:ring-2 focus:ring-white md:w-[440px]"
            />
            <button className="flex h-12 items-center gap-2 rounded-full bg-white px-4 text-black transition hover:bg-gray-100">
              Deliver now
              <span className="text-xs">▾</span>
            </button>
            <button className="h-12 rounded-full bg-black px-5 text-white transition hover:bg-gray-900">
              Search here
            </button>
          </div>
          <Link href="/login" className="text-sm font-semibold underline">
            Or Sign in
          </Link>
        </div>
      </div>
    </section>
  );
}

