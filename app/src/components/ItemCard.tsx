"use client";

import Link from "next/link";
import Image from "next/image";
import styled from "styled-components";

type Item = {
  id: number;
  name: string;
  price: number;
  listed: boolean;
  imageUrl?: string;
};

export default function ItemCard({ item }: { item: Item }) {
  return (
    <Card>
      <Thumb>
        {item.imageUrl ? (
          <Image
            src={item.imageUrl}
            alt=""
            fill
            sizes="(max-width: 768px) 100vw, 240px"
            style={{ objectFit: "cover" }}
          />
        ) : (
          <Placeholder>No Image</Placeholder>
        )}
      </Thumb>
      <Body>
        <Name>
          <Link href={`/items/${item.id}`}>{item.name}</Link>
        </Name>
        <Meta>
          <Price>¥{item.price.toLocaleString()}</Price>
          <Status $listed={item.listed}>
            {item.listed ? "出品中" : "取引中/終了"}
          </Status>
        </Meta>
      </Body>
    </Card>
  );
}

const Card = styled.article`
  display: grid;
  grid-template-rows: 160px auto;
  border-radius: 12px;
  border: 1px solid rgba(0, 0, 0, 0.08);
  overflow: hidden;
  background: #fff;
`;

const Thumb = styled.div`
  background: #f3f4f6; /* gray-100 */
  position: relative;
`;

const Placeholder = styled.div`
  width: 100%;
  height: 100%;
  display: grid;
  place-items: center;
  color: #6b7280;
  font-size: 12px;
`;

const Body = styled.div`
  padding: 12px 14px 14px;
  display: grid;
  gap: 8px;
`;

const Name = styled.h3`
  margin: 0;
  font-size: 16px;
  font-weight: 700;
  color: #111827;
`;

const Meta = styled.div`
  display: flex;
  align-items: center;
  justify-content: space-between;
`;

const Price = styled.span`
  font-weight: 800;
`;

const Status = styled.span<{ $listed: boolean }>`
  font-size: 12px;
  padding: 2px 8px;
  border-radius: 999px;
  color: ${({ $listed }) => ($listed ? "#065f46" : "#92400e")};
  background: ${({ $listed }) => ($listed ? "#d1fae5" : "#fef3c7")};
`;
