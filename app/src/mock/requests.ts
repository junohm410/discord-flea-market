export const requestedItemIds: number[] = [2];

export type PurchaseRequest = {
  id: number;
  itemId: number;
  userName: string;
  status: "requested" | "selected_as_buyer" | "not_selected";
};

export const mockPurchaseRequests: PurchaseRequest[] = [
  { id: 1, itemId: 1, userName: "Alice", status: "requested" },
  { id: 2, itemId: 1, userName: "Bob", status: "requested" },
  { id: 3, itemId: 2, userName: "Carol", status: "selected_as_buyer" },
];

const defaultExport = { requestedItemIds, mockPurchaseRequests };
export default defaultExport;
