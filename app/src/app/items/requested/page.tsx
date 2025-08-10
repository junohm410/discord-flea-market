// RSC: 自分の申請（モック）
import ItemsList from "../_components/ItemsList";
// TODO: Rails API 接続後はモックを削除し、`/api/items/requested-by-me` などで取得に置換する
import { mockItems } from "@/mock/items";
import { requestedItemIds } from "@/mock/requests";

const RequestedItemsPage = () => {
  // TODO: 本来は現在ユーザーの申請のみを返す
  const items = mockItems.filter((it) => requestedItemIds.includes(it.id));
  return <ItemsList initialItems={items} title="自分が購入希望を出した商品" />;
};

export default RequestedItemsPage;
