import { notFound } from "next/navigation";
// TODO: Rails API 接続後はモックを削除し、BFF or 直接フェッチに置換する
import { mockItems } from "@/mock/items";
import ItemDetailView from "./_components/ItemDetailView";

export default async function ItemDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const itemId = Number(id);
  const item = mockItems.find((it) => it.id === itemId);
  if (!item) return notFound();

  return <ItemDetailView item={item} />;
}
