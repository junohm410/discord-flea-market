import { notFound } from "next/navigation";
// TODO: Rails API 接続後はモックを削除し、BFF or 直接フェッチに置換する
import { mockItems } from "@/mock/items";
import ItemUpsertForm, {
  ItemUpsertInitial,
} from "@/components/items/ItemUpsertForm";

const ItemEditPage = async ({
  params,
}: {
  params: Promise<{ id: string }>;
}) => {
  const { id } = await params;
  const itemId = Number(id);
  const item = mockItems.find((it) => it.id === itemId);
  if (!item) return notFound();

  const initial: ItemUpsertInitial = {
    name: item.name,
    price: item.price,
    // TODO: モック拡張時に型へ追加する
    description: undefined,
    deadline: undefined,
    imageUrl: item.imageUrl,
  };

  return <ItemUpsertForm mode="edit" initial={initial} />;
};

export default ItemEditPage;
