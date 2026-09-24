import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "The Polymathic | Young Minds. Big Ideas. Real Conversations.",
  description: "A student writing and discussion platform for writers ages 14–21.",
  keywords: ["student writers","student journalism","student essays","writing","The Polymathic"],
  manifest: "/manifest.webmanifest",
  icons: { icon: "/icon.svg" },
  openGraph: {
    title: "The Polymathic",
    description: "Young Minds. Big Ideas. Real Conversations.",
    type: "website"
  }
};

export default function RootLayout({children}:{children:React.ReactNode}) {
  return <html lang="en"><body>{children}</body></html>;
}