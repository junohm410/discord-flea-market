"use client";

import { useState } from "react";
import ItemCard from "@/components/items/ItemCard";
import Link from "next/link";
import styled from "styled-components";
import Pagination from "@/components/Pagination";

type Item = {
  id: number;
  name: string;
  price: number;
  listed: boolean;
  imageUrl?: string;
};

type ItemsListProps = {
  initialItems: Item[];
  title?: string;
};

const ItemsList = ({ initialItems, title }: ItemsListProps) => {
  const [items] = useState(initialItems);
  const [page, setPage] = useState(1);
  const pageSize = 12;
  const total = items.length;
  const totalPages = Math.max(1, Math.ceil(total / pageSize));
  const start = (page - 1) * pageSize;
  const current = items.slice(start, start + pageSize);
  const canPrev = page > 1;
  const canNext = page < totalPages;

  return (
    <Container>
      <Toolbar>
        <div style={{ display: "grid", gap: 4 }}>
          <Title>{title ?? "出品中の商品"}</Title>
          <CountText>
            {total}件{totalPages > 1 ? `（${page}/${totalPages}）` : ""}
          </CountText>
        </div>
        <NewButton href="/items/new">商品を出品する</NewButton>
      </Toolbar>
      {current.length > 0 ? (
        <>
          <Grid>
            {current.map((item) => (
              <ItemCard key={item.id} item={item} />
            ))}
          </Grid>
          <Pagination
            page={page}
            totalPages={totalPages}
            canPrev={canPrev}
            canNext={canNext}
            onPrev={() => setPage((p) => Math.max(1, p - 1))}
            onNext={() => setPage((p) => Math.min(totalPages, p + 1))}
          />
        </>
      ) : (
        <Empty>
          <p>まだ商品がありません。</p>
          <NewButton href="/items/new">最初の出品を作成する</NewButton>
        </Empty>
      )}
    </Container>
  );
};

const Container = styled.div`
  padding: 24px 24px 48px;
  max-width: 1200px;
  margin: 0 auto;
`;

const Toolbar = styled.div`
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
`;

const Title = styled.h1`
  margin: 0;
  font-size: 22px;
  font-weight: 800;
`;

const CountText = styled.span`
  font-size: 12px;
  color: #6b7280;
`;

const NewButton = styled(Link)`
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 10px 16px;
  border-radius: 8px;
  background: #111827;
  color: #fff;
  font-weight: 700;
  text-decoration: none;
`;

const Grid = styled.div`
  display: grid;
  gap: 16px;
  grid-template-columns: 1fr;

  @media (min-width: 640px) {
    grid-template-columns: repeat(2, 1fr);
    gap: 20px;
  }

  @media (min-width: 1024px) {
    grid-template-columns: repeat(3, 1fr);
    gap: 24px;
  }

  @media (min-width: 1280px) {
    grid-template-columns: repeat(4, 1fr);
  }
`;

const Empty = styled.div`
  display: grid;
  gap: 12px;
  place-items: center;
  padding: 48px 0;
  color: #6b7280;
`;

export default ItemsList;
