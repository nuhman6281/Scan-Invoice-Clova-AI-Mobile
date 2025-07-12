"use client";

import { useEffect, useState } from "react";
import { useRouter, usePathname } from "next/navigation";
import Layout from "@/components/Layout";
import { authAPI } from "@/lib/api";

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const [isLoading, setIsLoading] = useState(true);
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const router = useRouter();
  const pathname = usePathname();

  useEffect(() => {
    const checkAuth = async () => {
      const token = localStorage.getItem("admin_token");
      if (!token) {
        router.push("/login");
        return;
      }

      try {
        const response = await authAPI.me();
        if (response.data.success && response.data.data.user.isAdmin) {
          setIsAuthenticated(true);
        } else {
          localStorage.removeItem("admin_token");
          router.push("/login");
        }
      } catch (error) {
        localStorage.removeItem("admin_token");
        router.push("/login");
      } finally {
        setIsLoading(false);
      }
    };

    checkAuth();
  }, [router]);

  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-indigo-600"></div>
      </div>
    );
  }

  if (!isAuthenticated) {
    return null;
  }

  return <Layout>{children}</Layout>;
}
