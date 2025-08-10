"use client";

import { useState } from "react";
import ItemCard from "@/components/items/ItemCard";
import Link from "next/link";
import styled from "styled-components";

type Item = {
  id: number;
  name: string;
  price: number;
  listed: boolean;
  imageUrl?: string;
};

const ItemsList = ({ initialItems }: { initialItems: Item[] }) => {
  const [items] = useState(initialItems);
  return (
    <Container>
      <Toolbar>
        <Title>出品中の商品</Title>
        <NewButton href="/items/new">商品を出品する</NewButton>
      </Toolbar>
      <Grid>
        {items.map((item) => (
          <ItemCard key={item.id} item={item} />
        ))}
      </Grid>
    </Container>
  );
};

const Container = styled.div`
  padding: 24px;
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
  grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
  gap: 16px;
`;

export default ItemsList;
