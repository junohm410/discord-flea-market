// RSC: 自分の出品（モック）
import ItemsList from "../_components/ItemsList";
// TODO: Rails API 接続後はモックを削除し、`/api/items?owner=me` などで取得に置換する
import { mockItems } from "@/mock/items";

const ListedItemsPage = () => {
  // TODO: 本来は現在ユーザーの出品のみを返す。モックでは仮に listed=true のみ表示
  const items = mockItems.filter((it) => it.listed);
  return <ItemsList initialItems={items} title="自分の商品" />;
};

export default ListedItemsPage;
