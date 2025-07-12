"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import {
  BuildingStorefrontIcon,
  CubeIcon,
  UsersIcon,
  ChartBarIcon,
  PlusIcon,
  EyeIcon,
} from "@heroicons/react/24/outline";
import { analyticsAPI, shopsAPI, productsAPI, usersAPI } from "@/lib/api";
import toast from "react-hot-toast";

interface DashboardStats {
  totalShops: number;
  totalProducts: number;
  totalUsers: number;
  totalScans: number;
  successfulScans: number;
  totalSavings: number;
  avgProcessingTime: number;
  errorRate: number;
}

export default function DashboardPage() {
  const [stats, setStats] = useState<DashboardStats | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchDashboardData = async () => {
      try {
        const [analyticsRes, shopsRes, productsRes, usersRes] =
          await Promise.all([
            analyticsAPI.getDashboard(),
            shopsAPI.getAll({ limit: 1 }),
            productsAPI.getAll({ limit: 1 }),
            usersAPI.getAll({ limit: 1 }),
          ]);

        const analytics = analyticsRes.data;
        setStats({
          totalShops: shopsRes.data.total || 0,
          totalProducts: productsRes.data.total || 0,
          totalUsers: usersRes.data.total || 0,
          totalScans: analytics.totalScans || 0,
          successfulScans: analytics.successfulScans || 0,
          totalSavings: analytics.totalSavings || 0,
          avgProcessingTime: analytics.avgProcessingTime || 0,
          errorRate: analytics.errorRate || 0,
        });
      } catch (error) {
        toast.error("Failed to load dashboard data");
      } finally {
        setIsLoading(false);
      }
    };

    fetchDashboardData();
  }, []);

  const quickActions = [
    {
      name: "Add New Shop",
      href: "/shops/new",
      icon: BuildingStorefrontIcon,
      description: "Create a new shop entry",
    },
    {
      name: "Add New Product",
      href: "/products/new",
      icon: CubeIcon,
      description: "Add a new product to inventory",
    },
    {
      name: "View Analytics",
      href: "/analytics",
      icon: ChartBarIcon,
      description: "View detailed analytics",
    },
    {
      name: "Manage Users",
      href: "/users",
      icon: UsersIcon,
      description: "Manage user accounts",
    },
  ];

  if (isLoading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-indigo-600"></div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-semibold text-gray-900">Dashboard</h1>
        <p className="mt-1 text-sm text-gray-500">
          Overview of your CLOVA Invoice Scanner system
        </p>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4">
        <div className="bg-white overflow-hidden shadow rounded-lg">
          <div className="p-5">
            <div className="flex items-center">
              <div className="flex-shrink-0">
                <BuildingStorefrontIcon className="h-6 w-6 text-gray-400" />
              </div>
              <div className="ml-5 w-0 flex-1">
                <dl>
                  <dt className="text-sm font-medium text-gray-500 truncate">
                    Total Shops
                  </dt>
                  <dd className="text-lg font-medium text-gray-900">
                    {stats?.totalShops || 0}
                  </dd>
                </dl>
              </div>
            </div>
          </div>
        </div>

        <div className="bg-white overflow-hidden shadow rounded-lg">
          <div className="p-5">
            <div className="flex items-center">
              <div className="flex-shrink-0">
                <CubeIcon className="h-6 w-6 text-gray-400" />
              </div>
              <div className="ml-5 w-0 flex-1">
                <dl>
                  <dt className="text-sm font-medium text-gray-500 truncate">
                    Total Products
                  </dt>
                  <dd className="text-lg font-medium text-gray-900">
                    {stats?.totalProducts || 0}
                  </dd>
                </dl>
              </div>
            </div>
          </div>
        </div>

        <div className="bg-white overflow-hidden shadow rounded-lg">
          <div className="p-5">
            <div className="flex items-center">
              <div className="flex-shrink-0">
                <UsersIcon className="h-6 w-6 text-gray-400" />
              </div>
              <div className="ml-5 w-0 flex-1">
                <dl>
                  <dt className="text-sm font-medium text-gray-500 truncate">
                    Total Users
                  </dt>
                  <dd className="text-lg font-medium text-gray-900">
                    {stats?.totalUsers || 0}
                  </dd>
                </dl>
              </div>
            </div>
          </div>
        </div>

        <div className="bg-white overflow-hidden shadow rounded-lg">
          <div className="p-5">
            <div className="flex items-center">
              <div className="flex-shrink-0">
                <ChartBarIcon className="h-6 w-6 text-gray-400" />
              </div>
              <div className="ml-5 w-0 flex-1">
                <dl>
                  <dt className="text-sm font-medium text-gray-500 truncate">
                    Total Scans
                  </dt>
                  <dd className="text-lg font-medium text-gray-900">
                    {stats?.totalScans || 0}
                  </dd>
                </dl>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Performance Stats */}
      <div className="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3">
        <div className="bg-white overflow-hidden shadow rounded-lg">
          <div className="p-5">
            <dl>
              <dt className="text-sm font-medium text-gray-500 truncate">
                Success Rate
              </dt>
              <dd className="mt-1 text-3xl font-semibold text-green-600">
                {stats?.totalScans
                  ? Math.round((stats.successfulScans / stats.totalScans) * 100)
                  : 0}
                %
              </dd>
            </dl>
          </div>
        </div>

        <div className="bg-white overflow-hidden shadow rounded-lg">
          <div className="p-5">
            <dl>
              <dt className="text-sm font-medium text-gray-500 truncate">
                Total Savings
              </dt>
              <dd className="mt-1 text-3xl font-semibold text-green-600">
                ${stats?.totalSavings?.toFixed(2) || "0.00"}
              </dd>
            </dl>
          </div>
        </div>

        <div className="bg-white overflow-hidden shadow rounded-lg">
          <div className="p-5">
            <dl>
              <dt className="text-sm font-medium text-gray-500 truncate">
                Avg Processing Time
              </dt>
              <dd className="mt-1 text-3xl font-semibold text-blue-600">
                {stats?.avgProcessingTime
                  ? Math.round(stats.avgProcessingTime)
                  : 0}
                ms
              </dd>
            </dl>
          </div>
        </div>
      </div>

      {/* Quick Actions */}
      <div>
        <h2 className="text-lg font-medium text-gray-900 mb-4">
          Quick Actions
        </h2>
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
          {quickActions.map((action) => (
            <Link
              key={action.name}
              href={action.href}
              className="relative group bg-white p-6 focus-within:ring-2 focus-within:ring-inset focus-within:ring-indigo-500 rounded-lg shadow hover:shadow-md transition-shadow"
            >
              <div>
                <span className="rounded-lg inline-flex p-3 bg-indigo-50 text-indigo-700 ring-4 ring-white">
                  <action.icon className="h-6 w-6" />
                </span>
              </div>
              <div className="mt-8">
                <h3 className="text-lg font-medium">
                  <span className="absolute inset-0" aria-hidden="true" />
                  {action.name}
                </h3>
                <p className="mt-2 text-sm text-gray-500">
                  {action.description}
                </p>
              </div>
              <span
                className="pointer-events-none absolute top-6 right-6 text-gray-300 group-hover:text-gray-400"
                aria-hidden="true"
              >
                <PlusIcon className="h-6 w-6" />
              </span>
            </Link>
          ))}
        </div>
      </div>
    </div>
  );
}
