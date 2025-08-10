"use client";

import Image from "next/image";
import styled from "styled-components";
import ItemPrice from "@/components/ItemPrice";
import ItemStatusLabel from "@/components/ItemStatusLabel";

type Item = {
  id: number;
  name: string;
  price: number;
  listed: boolean;
  imageUrl?: string;
};

export default function ItemDetailView({ item }: { item: Item }) {
  return (
    <Main>
      <Grid>
        <ImageWrap>
          {item.imageUrl && (
            <Image
              src={item.imageUrl}
              alt=""
              fill
              sizes="(max-width: 768px) 100vw, 480px"
              style={{ objectFit: "cover" }}
            />
          )}
        </ImageWrap>
        <InfoSection>
          <Title>{item.name}</Title>
          <InfoRow>
            <ItemPrice price={item.price} />
            <ItemStatusLabel listed={item.listed} />
          </InfoRow>
          <Desc>
            この商品はモックデータです。詳細情報は後続のAPI接続で拡張します。
          </Desc>
        </InfoSection>
      </Grid>
    </Main>
  );
}

const Main = styled.main`
  padding: 24px;
`;

const Grid = styled.div`
  display: grid;
  grid-template-columns: minmax(260px, 480px) 1fr;
  gap: 24px;
  align-items: start;
`;

const ImageWrap = styled.div`
  position: relative;
  aspect-ratio: 4 / 3;
  background: #f3f4f6;
`;

const InfoSection = styled.section`
  display: grid;
  gap: 12px;
`;

const Title = styled.h1`
  margin: 0;
  font-size: 22px;
  font-weight: 800;
`;

const InfoRow = styled.div`
  display: flex;
  align-items: center;
  gap: 12px;
`;

const Desc = styled.p`
  color: #6b7280;
  margin: 0;
`;
