"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import {
  PlusIcon,
  MagnifyingGlassIcon,
  PencilIcon,
  TrashIcon,
  EyeIcon,
  BuildingStorefrontIcon,
} from "@heroicons/react/24/outline";
import { productsAPI, shopsAPI, Product, Shop } from "@/lib/api";
import toast from "react-hot-toast";

export default function ProductsPage() {
  const [products, setProducts] = useState<Product[]>([]);
  const [shops, setShops] = useState<Shop[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState("");
  const [filterCategory, setFilterCategory] = useState("");
  const [filterShop, setFilterShop] = useState("");

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      const [productsRes, shopsRes] = await Promise.all([
        productsAPI.getAll(),
        shopsAPI.getAll(),
      ]);

      // Handle different response structures for products
      const productsData =
        productsRes.data?.data ||
        productsRes.data?.products ||
        productsRes.data ||
        [];
      setProducts(Array.isArray(productsData) ? productsData : []);

      // Handle different response structures for shops
      const shopsData =
        shopsRes.data?.data || shopsRes.data?.shops || shopsRes.data || [];
      setShops(Array.isArray(shopsData) ? shopsData : []);
    } catch (error) {
      console.error("Error fetching data:", error);
      toast.error("Failed to load data");
      setProducts([]);
      setShops([]);
    } finally {
      setIsLoading(false);
    }
  };

  const fetchProducts = async () => {
    try {
      const response = await productsAPI.getAll();
      // Handle different response structures
      const productsData =
        response.data?.data || response.data?.products || response.data || [];
      setProducts(Array.isArray(productsData) ? productsData : []);
    } catch (error) {
      console.error("Error fetching products:", error);
      toast.error("Failed to load products");
      setProducts([]);
    } finally {
      setIsLoading(false);
    }
  };

  const handleDelete = async (id: string) => {
    if (!confirm("Are you sure you want to delete this product?")) return;

    try {
      await productsAPI.delete(id);
      toast.success("Product deleted successfully");
      fetchData();
    } catch (error) {
      toast.error("Failed to delete product");
    }
  };

  const filteredProducts = products.filter((product: Product) => {
    const matchesSearch =
      product.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      product.brand?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      product.keywords.some((keyword) =>
        keyword.toLowerCase().includes(searchTerm.toLowerCase())
      );
    const matchesCategory =
      !filterCategory || product.category === filterCategory;
    const matchesShop = !filterShop || product.shopId === filterShop;
    return matchesSearch && matchesCategory && matchesShop;
  });

  const categories = [
    ...new Set(
      products.map((product: Product) => product.category).filter(Boolean)
    ),
  ];

  const getShopName = (shopId: string) => {
    const shop = shops.find((s) => s.id === shopId);
    return shop?.name || "Unknown Shop";
  };

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
          <h1 className="text-2xl font-semibold text-gray-900">Products</h1>
          <p className="mt-1 text-sm text-gray-500">
            Manage product inventory and pricing
          </p>
        </div>
        <Link
          href="/products/new"
          className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
        >
          <PlusIcon className="h-4 w-4 mr-2" />
          Add Product
        </Link>
      </div>

      {/* Filters */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <div className="relative">
          <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
            <MagnifyingGlassIcon className="h-5 w-5 text-gray-400" />
          </div>
          <input
            type="text"
            placeholder="Search products..."
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
          className="block w-full px-3 py-2 border border-gray-300 rounded-md leading-5 bg-white focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
        >
          <option value="">All Categories</option>
          {categories.map((category) => (
            <option key={category} value={category}>
              {category}
            </option>
          ))}
        </select>
        <select
          value={filterShop}
          onChange={(e: React.ChangeEvent<HTMLSelectElement>) =>
            setFilterShop(e.target.value)
          }
          className="block w-full px-3 py-2 border border-gray-300 rounded-md leading-5 bg-white focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
        >
          <option value="">All Shops</option>
          {shops.map((shop) => (
            <option key={shop.id} value={shop.id}>
              {shop.name}
            </option>
          ))}
        </select>
      </div>

      {/* Products List */}
      <div className="bg-white shadow overflow-hidden sm:rounded-md">
        <ul className="divide-y divide-gray-200">
          {filteredProducts.map((product: Product) => (
            <li key={product.id}>
              <div className="px-4 py-4 sm:px-6">
                <div className="flex items-center justify-between">
                  <div className="flex items-center">
                    <div className="flex-shrink-0 h-12 w-12">
                      {product.imageUrl ? (
                        <img
                          className="h-12 w-12 rounded-lg object-cover"
                          src={product.imageUrl}
                          alt={product.name}
                        />
                      ) : (
                        <div className="h-12 w-12 rounded-lg bg-gray-300 flex items-center justify-center">
                          <span className="text-sm font-medium text-gray-700">
                            {product.name.charAt(0).toUpperCase()}
                          </span>
                        </div>
                      )}
                    </div>
                    <div className="ml-4">
                      <div className="flex items-center">
                        <p className="text-sm font-medium text-gray-900">
                          {product.name}
                        </p>
                        {!product.isAvailable && (
                          <span className="ml-2 inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                            Out of Stock
                          </span>
                        )}
                      </div>
                      <div className="mt-1 flex items-center text-sm text-gray-500">
                        <BuildingStorefrontIcon className="h-4 w-4 mr-1" />
                        <p>{getShopName(product.shopId)}</p>
                        {product.category && (
                          <>
                            <span className="mx-1">•</span>
                            <p>{product.category}</p>
                          </>
                        )}
                        {product.brand && (
                          <>
                            <span className="mx-1">•</span>
                            <p>{product.brand}</p>
                          </>
                        )}
                      </div>
                      <div className="mt-1 flex items-center text-sm text-gray-500">
                        <p className="font-medium text-green-600">
                          ₹
                          {Object.is(product.price, null)
                            ? "N/A"
                            : parseFloat(product.price.toString()).toFixed(2)}
                        </p>
                        {product.stockQuantity !== null && (
                          <>
                            <span className="mx-1">•</span>
                            <p>Stock: {product.stockQuantity}</p>
                          </>
                        )}
                        {product.weight && (
                          <>
                            <span className="mx-1">•</span>
                            <p>
                              {product.weight}
                              {product.unit}
                            </p>
                          </>
                        )}
                      </div>
                      {product.keywords.length > 0 && (
                        <div className="mt-1 flex flex-wrap gap-1">
                          {product.keywords
                            .slice(0, 3)
                            .map((keyword, index) => (
                              <span
                                key={index}
                                className="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-gray-100 text-gray-800"
                              >
                                {keyword}
                              </span>
                            ))}
                          {product.keywords.length > 3 && (
                            <span className="text-xs text-gray-500">
                              +{product.keywords.length - 3} more
                            </span>
                          )}
                        </div>
                      )}
                    </div>
                  </div>
                  <div className="flex items-center space-x-2">
                    <Link
                      href={`/products/${product.id}`}
                      className="text-indigo-600 hover:text-indigo-900"
                    >
                      <EyeIcon className="h-5 w-5" />
                    </Link>
                    <Link
                      href={`/products/${product.id}/edit`}
                      className="text-gray-600 hover:text-gray-900"
                    >
                      <PencilIcon className="h-5 w-5" />
                    </Link>
                    <button
                      onClick={() => handleDelete(product.id)}
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
        {filteredProducts.length === 0 && (
          <div className="text-center py-12">
            <p className="text-gray-500">No products found</p>
          </div>
        )}
      </div>
    </div>
  );
}
