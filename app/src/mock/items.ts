export type MockItem = {
  id: number;
  name: string;
  price: number;
  listed: boolean;
  imageUrl?: string;
};

export const mockItems: MockItem[] = [
  {
    id: 1,
    name: "技術書セット",
    price: 1200,
    listed: true,
    imageUrl: "/images/mock/items/1.jpg",
  },
  {
    id: 2,
    name: "メカニカルキーボード",
    price: 4500,
    listed: false,
    imageUrl: "/images/mock/items/2.jpg",
  },
  {
    id: 3,
    name: "ゲーミングマウス",
    price: 2000,
    listed: true,
    imageUrl: "/images/mock/items/3.jpg",
  },
];

const defaultExport = { items: mockItems };
export default defaultExport;
