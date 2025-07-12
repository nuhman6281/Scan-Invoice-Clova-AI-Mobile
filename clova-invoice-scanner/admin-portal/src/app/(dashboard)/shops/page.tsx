"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import {
  PlusIcon,
  MagnifyingGlassIcon,
  PencilIcon,
  TrashIcon,
  EyeIcon,
} from "@heroicons/react/24/outline";
import { shopsAPI, Shop } from "@/lib/api";
import toast from "react-hot-toast";

export default function ShopsPage() {
  const [shops, setShops] = useState<Shop[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState("");
  const [filterCategory, setFilterCategory] = useState("");

  useEffect(() => {
    fetchShops();
  }, []);

  const fetchShops = async () => {
    try {
      const response = await shopsAPI.getAll();
      // Handle different response structures
      const shopsData =
        response.data?.data || response.data?.shops || response.data || [];
      setShops(Array.isArray(shopsData) ? shopsData : []);
    } catch (error) {
      console.error("Error fetching shops:", error);
      toast.error("Failed to load shops");
      setShops([]);
    } finally {
      setIsLoading(false);
    }
  };

  const handleDelete = async (id: string) => {
    if (!confirm("Are you sure you want to delete this shop?")) return;

    try {
      await shopsAPI.delete(id);
      toast.success("Shop deleted successfully");
      fetchShops();
    } catch (error) {
      toast.error("Failed to delete shop");
    }
  };

  const filteredShops = shops.filter((shop: Shop) => {
    const matchesSearch =
      shop.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      shop.address?.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesCategory = !filterCategory || shop.category === filterCategory;
    return matchesSearch && matchesCategory;
  });

  const categories = [
    ...new Set(shops.map((shop: Shop) => shop.category).filter(Boolean)),
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
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-semibold text-gray-900">Shops</h1>
          <p className="mt-1 text-sm text-gray-500">
            Manage shop information and locations
          </p>
        </div>
        <Link
          href="/shops/new"
          className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
        >
          <PlusIcon className="h-4 w-4 mr-2" />
          Add Shop
        </Link>
      </div>

      {/* Filters */}
      <div className="flex flex-col sm:flex-row gap-4">
        <div className="relative flex-1">
          <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
            <MagnifyingGlassIcon className="h-5 w-5 text-gray-400" />
          </div>
          <input
            type="text"
            placeholder="Search shops..."
            value={searchTerm}
            onChange={(e: React.ChangeEvent<HTMLInputElement>) =>
              setSearchTerm(e.target.value)
            }
            className="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md leading-5 bg-white placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
          />
        </div>
        <select
          value={filterCategory}
          onChange={(e: React.ChangeEvent<HTMLSelectElement>) =>
            setFilterCategory(e.target.value)
          }
          className="block w-full sm:w-48 px-3 py-2 border border-gray-300 rounded-md leading-5 bg-white focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
        >
          <option value="">All Categories</option>
          {categories.map((category) => (
            <option key={category} value={category}>
              {category}
            </option>
          ))}
        </select>
      </div>

      {/* Shops List */}
      <div className="bg-white shadow overflow-hidden sm:rounded-md">
        <ul className="divide-y divide-gray-200">
          {filteredShops.map((shop: Shop) => (
            <li key={shop.id}>
              <div className="px-4 py-4 sm:px-6">
                <div className="flex items-center justify-between">
                  <div className="flex items-center">
                    <div className="flex-shrink-0 h-10 w-10">
                      {shop.imageUrl ? (
                        <img
                          className="h-10 w-10 rounded-full object-cover"
                          src={shop.imageUrl}
                          alt={shop.name}
                        />
                      ) : (
                        <div className="h-10 w-10 rounded-full bg-gray-300 flex items-center justify-center">
                          <span className="text-sm font-medium text-gray-700">
                            {shop.name.charAt(0).toUpperCase()}
                          </span>
                        </div>
                      )}
                    </div>
                    <div className="ml-4">
                      <div className="flex items-center">
                        <p className="text-sm font-medium text-gray-900">
                          {shop.name}
                        </p>
                        {shop.isPremium && (
                          <span className="ml-2 inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
                            Premium
                          </span>
                        )}
                      </div>
                      <div className="mt-1 flex items-center text-sm text-gray-500">
                        <p>{shop.address}</p>
                        {shop.category && (
                          <>
                            <span className="mx-1">•</span>
                            <p>{shop.category}</p>
                          </>
                        )}
                        {shop.rating && (
                          <>
                            <span className="mx-1">•</span>
                            <p>⭐ {shop.rating}</p>
                          </>
                        )}
                      </div>
                    </div>
                  </div>
                  <div className="flex items-center space-x-2">
                    <Link
                      href={`/shops/${shop.id}`}
                      className="text-indigo-600 hover:text-indigo-900"
                    >
                      <EyeIcon className="h-5 w-5" />
                    </Link>
                    <Link
                      href={`/shops/${shop.id}/edit`}
                      className="text-gray-600 hover:text-gray-900"
                    >
                      <PencilIcon className="h-5 w-5" />
                    </Link>
                    <button
                      onClick={() => handleDelete(shop.id)}
                      className="text-red-600 hover:text-red-900"
                    >
                      <TrashIcon className="h-5 w-5" />
                    </button>
                  </div>
                </div>
              </div>
            </li>
          ))}
        </ul>
        {filteredShops.length === 0 && (
          <div className="text-center py-12">
            <p className="text-gray-500">No shops found</p>
          </div>
        )}
      </div>
    </div>
  );
}
