// Root page — serves the full SchemaForge AI single-page application
// In a production Next.js build this would be split into proper route segments.
// For now it renders the landing page with navigation to the app shell.
import SchemaForgeApp from "@/components/SchemaForgeApp";

export default function Home() {
  return <SchemaForgeApp />;
}
