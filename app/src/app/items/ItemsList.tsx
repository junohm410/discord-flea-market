"use client";

import { useState } from "react";
import ItemCard from "@/components/ItemCard";

type Item = {
  id: number;
  name: string;
  price: number;
  listed: boolean;
  imageUrl?: string;
};

export default function ItemsList({ initialItems }: { initialItems: Item[] }) {
  const [items] = useState(initialItems);
  return (
    <div
      style={{
        display: "grid",
        gridTemplateColumns: "repeat(auto-fill, minmax(240px, 1fr))",
        gap: 16,
        padding: 24,
      }}
    >
      {items.map((item) => (
        <ItemCard key={item.id} item={item} />
      ))}
    </div>
  );
}
