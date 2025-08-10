export type Comment = {
  id: number;
  itemId: number;
  author: string;
  body: string;
  createdAt: string;
};

export const mockComments: Comment[] = [
  {
    id: 1,
    itemId: 1,
    author: "Alice",
    body: "興味あります！まだ出品中でしょうか？",
    createdAt: "2025-08-01T10:00:00Z",
  },
  {
    id: 2,
    itemId: 1,
    author: "Bob",
    body: "写真をもう1枚お願いできますか？",
    createdAt: "2025-08-01T11:00:00Z",
  },
];

const defaultExport = { mockComments };
export default defaultExport;
