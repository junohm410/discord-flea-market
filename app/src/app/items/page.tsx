// RSC: Items 一覧（当面は固定 JSON）
import ItemsList from "./_components/ItemsList";
// TODO: Rails API 接続後はモックを削除し、`cookies()`付きのAPIフェッチ or BFF経由に置換する
import { mockItems } from "@/mock/items";

const ItemsPage: React.FC = () => {
  // TODO: ここで渡している `mockItems` は暫定。`/api/items` から取得したデータに差し替える
  return <ItemsList initialItems={mockItems} />;
};

export default ItemsPage;
