import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  experimental: { typedRoutes: true },
  images: { domains: ["avatars.githubusercontent.com"] },
};

export default nextConfig;
