import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "SchemaForge AI — Transform Plain English Into Production-Ready Database Schemas",
  description:
    "AI-powered database design platform. Describe your system in plain English and get normalized schemas, SQL scripts, ER diagrams, and documentation instantly.",
  keywords: ["database design", "AI", "schema generator", "SQL", "ER diagram", "PostgreSQL"],
  openGraph: {
    title: "SchemaForge AI",
    description: "Transform Plain English Into Production-Ready Database Schemas",
    type: "website",
  },
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body>{children}</body>
    </html>
  );
}
