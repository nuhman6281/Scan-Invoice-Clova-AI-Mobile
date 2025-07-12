"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { shopsAPI } from "@/lib/api";
import toast from "react-hot-toast";

const shopSchema = z.object({
  name: z.string().min(1, "Shop name is required"),
  address: z.string().optional(),
  latitude: z.number().min(-90).max(90),
  longitude: z.number().min(-180).max(180),
  phone: z.string().optional(),
  rating: z.number().min(0).max(5).optional(),
  isPremium: z.boolean(),
  category: z.string().optional(),
  imageUrl: z.string().url().optional().or(z.literal("")),
  description: z.string().optional(),
  openingHours: z.string().optional(),
});

type ShopForm = z.infer<typeof shopSchema>;

export default function NewShopPage() {
  const [isLoading, setIsLoading] = useState(false);
  const router = useRouter();

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<ShopForm>({
    resolver: zodResolver(shopSchema),
    defaultValues: {
      isPremium: false,
      rating: 0,
    },
  });

  const onSubmit = async (data: ShopForm) => {
    setIsLoading(true);
    try {
      await shopsAPI.create(data);
      toast.success("Shop created successfully!");
      router.push("/shops");
    } catch (error: any) {
      toast.error(error.response?.data?.message || "Failed to create shop");
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="max-w-2xl mx-auto">
      <div className="mb-6">
        <h1 className="text-2xl font-semibold text-gray-900">Add New Shop</h1>
        <p className="mt-1 text-sm text-gray-500">
          Create a new shop entry with location and details
        </p>
      </div>

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
        <div className="bg-white shadow rounded-lg p-6">
          <div className="grid grid-cols-1 gap-6 sm:grid-cols-2">
            {/* Shop Name */}
            <div className="sm:col-span-2">
              <label
                htmlFor="name"
                className="block text-sm font-medium text-gray-700"
              >
                Shop Name *
              </label>
              <input
                {...register("name")}
                type="text"
                id="name"
                className={`mt-1 block w-full border rounded-md px-3 py-2 focus:outline-none focus:ring-1 sm:text-sm ${
                  errors.name
                    ? "border-red-300 focus:ring-red-500 focus:border-red-500"
                    : "border-gray-300 focus:ring-indigo-500 focus:border-indigo-500"
                }`}
              />
              {errors.name && (
                <p className="mt-1 text-sm text-red-600">
                  {errors.name.message}
                </p>
              )}
            </div>

            {/* Address */}
            <div className="sm:col-span-2">
              <label
                htmlFor="address"
                className="block text-sm font-medium text-gray-700"
              >
                Address
              </label>
              <textarea
                {...register("address")}
                id="address"
                rows={3}
                className={`mt-1 block w-full border rounded-md px-3 py-2 focus:outline-none focus:ring-1 sm:text-sm ${
                  errors.address
                    ? "border-red-300 focus:ring-red-500 focus:border-red-500"
                    : "border-gray-300 focus:ring-indigo-500 focus:border-indigo-500"
                }`}
              />
              {errors.address && (
                <p className="mt-1 text-sm text-red-600">
                  {errors.address.message}
                </p>
              )}
            </div>

            {/* Latitude */}
            <div>
              <label
                htmlFor="latitude"
                className="block text-sm font-medium text-gray-700"
              >
                Latitude *
              </label>
              <input
                {...register("latitude", { valueAsNumber: true })}
                type="number"
                step="any"
                id="latitude"
                placeholder="37.7749"
                className={`mt-1 block w-full border rounded-md px-3 py-2 focus:outline-none focus:ring-1 sm:text-sm ${
                  errors.latitude
                    ? "border-red-300 focus:ring-red-500 focus:border-red-500"
                    : "border-gray-300 focus:ring-indigo-500 focus:border-indigo-500"
                }`}
              />
              {errors.latitude && (
                <p className="mt-1 text-sm text-red-600">
                  {errors.latitude.message}
                </p>
              )}
            </div>

            {/* Longitude */}
            <div>
              <label
                htmlFor="longitude"
                className="block text-sm font-medium text-gray-700"
              >
                Longitude *
              </label>
              <input
                {...register("longitude", { valueAsNumber: true })}
                type="number"
                step="any"
                id="longitude"
                placeholder="-122.4194"
                className={`mt-1 block w-full border rounded-md px-3 py-2 focus:outline-none focus:ring-1 sm:text-sm ${
                  errors.longitude
                    ? "border-red-300 focus:ring-red-500 focus:border-red-500"
                    : "border-gray-300 focus:ring-indigo-500 focus:border-indigo-500"
                }`}
              />
              {errors.longitude && (
                <p className="mt-1 text-sm text-red-600">
                  {errors.longitude.message}
                </p>
              )}
            </div>

            {/* Phone */}
            <div>
              <label
                htmlFor="phone"
                className="block text-sm font-medium text-gray-700"
              >
                Phone
              </label>
              <input
                {...register("phone")}
                type="tel"
                id="phone"
                className={`mt-1 block w-full border rounded-md px-3 py-2 focus:outline-none focus:ring-1 sm:text-sm ${
                  errors.phone
                    ? "border-red-300 focus:ring-red-500 focus:border-red-500"
                    : "border-gray-300 focus:ring-indigo-500 focus:border-indigo-500"
                }`}
              />
              {errors.phone && (
                <p className="mt-1 text-sm text-red-600">
                  {errors.phone.message}
                </p>
              )}
            </div>

            {/* Rating */}
            <div>
              <label
                htmlFor="rating"
                className="block text-sm font-medium text-gray-700"
              >
                Rating
              </label>
              <input
                {...register("rating", { valueAsNumber: true })}
                type="number"
                min="0"
                max="5"
                step="0.1"
                id="rating"
                className={`mt-1 block w-full border rounded-md px-3 py-2 focus:outline-none focus:ring-1 sm:text-sm ${
                  errors.rating
                    ? "border-red-300 focus:ring-red-500 focus:border-red-500"
                    : "border-gray-300 focus:ring-indigo-500 focus:border-indigo-500"
                }`}
              />
              {errors.rating && (
                <p className="mt-1 text-sm text-red-600">
                  {errors.rating.message}
                </p>
              )}
            </div>

            {/* Category */}
            <div>
              <label
                htmlFor="category"
                className="block text-sm font-medium text-gray-700"
              >
                Category
              </label>
              <select
                {...register("category")}
                id="category"
                className={`mt-1 block w-full border rounded-md px-3 py-2 focus:outline-none focus:ring-1 sm:text-sm ${
                  errors.category
                    ? "border-red-300 focus:ring-red-500 focus:border-red-500"
                    : "border-gray-300 focus:ring-indigo-500 focus:border-indigo-500"
                }`}
              >
                <option value="">Select category</option>
                <option value="Grocery">Grocery</option>
                <option value="Electronics">Electronics</option>
                <option value="Clothing">Clothing</option>
                <option value="Restaurant">Restaurant</option>
                <option value="Pharmacy">Pharmacy</option>
                <option value="Hardware">Hardware</option>
                <option value="Other">Other</option>
              </select>
              {errors.category && (
                <p className="mt-1 text-sm text-red-600">
                  {errors.category.message}
                </p>
              )}
            </div>

            {/* Image URL */}
            <div>
              <label
                htmlFor="imageUrl"
                className="block text-sm font-medium text-gray-700"
              >
                Image URL
              </label>
              <input
                {...register("imageUrl")}
                type="url"
                id="imageUrl"
                placeholder="https://example.com/image.jpg"
                className={`mt-1 block w-full border rounded-md px-3 py-2 focus:outline-none focus:ring-1 sm:text-sm ${
                  errors.imageUrl
                    ? "border-red-300 focus:ring-red-500 focus:border-red-500"
                    : "border-gray-300 focus:ring-indigo-500 focus:border-indigo-500"
                }`}
              />
              {errors.imageUrl && (
                <p className="mt-1 text-sm text-red-600">
                  {errors.imageUrl.message}
                </p>
              )}
            </div>

            {/* Premium Status */}
            <div className="sm:col-span-2">
              <div className="flex items-center">
                <input
                  {...register("isPremium")}
                  type="checkbox"
                  id="isPremium"
                  className="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded"
                />
                <label
                  htmlFor="isPremium"
                  className="ml-2 block text-sm text-gray-900"
                >
                  Premium Shop
                </label>
              </div>
            </div>

            {/* Opening Hours */}
            <div className="sm:col-span-2">
              <label
                htmlFor="openingHours"
                className="block text-sm font-medium text-gray-700"
              >
                Opening Hours
              </label>
              <textarea
                {...register("openingHours")}
                id="openingHours"
                rows={2}
                placeholder="Mon-Fri: 9AM-6PM, Sat: 10AM-4PM, Sun: Closed"
                className={`mt-1 block w-full border rounded-md px-3 py-2 focus:outline-none focus:ring-1 sm:text-sm ${
                  errors.openingHours
                    ? "border-red-300 focus:ring-red-500 focus:border-red-500"
                    : "border-gray-300 focus:ring-indigo-500 focus:border-indigo-500"
                }`}
              />
              {errors.openingHours && (
                <p className="mt-1 text-sm text-red-600">
                  {errors.openingHours.message}
                </p>
              )}
            </div>

            {/* Description */}
            <div className="sm:col-span-2">
              <label
                htmlFor="description"
                className="block text-sm font-medium text-gray-700"
              >
                Description
              </label>
              <textarea
                {...register("description")}
                id="description"
                rows={3}
                placeholder="Brief description of the shop..."
                className={`mt-1 block w-full border rounded-md px-3 py-2 focus:outline-none focus:ring-1 sm:text-sm ${
                  errors.description
                    ? "border-red-300 focus:ring-red-500 focus:border-red-500"
                    : "border-gray-300 focus:ring-indigo-500 focus:border-indigo-500"
                }`}
              />
              {errors.description && (
                <p className="mt-1 text-sm text-red-600">
                  {errors.description.message}
                </p>
              )}
            </div>
          </div>
        </div>

        <div className="flex justify-end space-x-3">
          <button
            type="button"
            onClick={() => router.back()}
            className="px-4 py-2 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
          >
            Cancel
          </button>
          <button
            type="submit"
            disabled={isLoading}
            className="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {isLoading ? "Creating..." : "Create Shop"}
          </button>
        </div>
      </form>
    </div>
  );
}
