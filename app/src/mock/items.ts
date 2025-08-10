export type MockItem = {
  id: number;
  name: string;
  price: number;
  listed: boolean;
  imageUrls?: string[];
  deadline?: string; // ISO8601
  seller?: { name: string; avatarUrl?: string };
};

export const mockItems: MockItem[] = [
  {
    id: 1,
    name: "技術書セット",
    price: 1200,
    listed: true,
    // TODO: モック画像使用中。API接続後は実画像URLに置換する
    imageUrls: ["/images/mock/items/1.jpg", "/images/mock/items/2.jpg"],
    deadline: "2025-08-31T23:59:59Z",
    seller: { name: "Alice", avatarUrl: "/favicon.ico" },
  },
  {
    id: 2,
    name: "メカニカルキーボード",
    price: 4500,
    listed: false,
    // TODO: モック画像使用中。API接続後は実画像URLに置換する
    imageUrls: ["/images/mock/items/2.jpg"],
    deadline: "2025-08-15T23:59:59Z",
    seller: { name: "Bob", avatarUrl: "/favicon.ico" },
  },
  {
    id: 3,
    name: "ゲーミングマウス",
    price: 2000,
    listed: true,
    // TODO: モック画像使用中。API接続後は実画像URLに置換する
    imageUrls: ["/images/mock/items/3.jpg"],
    deadline: "2025-09-10T23:59:59Z",
    seller: { name: "Carol", avatarUrl: "/favicon.ico" },
  },
];

const defaultExport = { items: mockItems };
export default defaultExport;
