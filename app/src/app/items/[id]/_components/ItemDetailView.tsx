"use client";

import Link from "next/link";
import styled from "styled-components";
import ItemPrice from "@/components/items/ItemPrice";
import ItemStatusLabel from "@/components/items/ItemStatusLabel";
import ItemComments from "./ItemComments";
import ItemDeadline from "@/components/items/ItemDeadline";
import ItemSeller from "@/components/items/ItemSeller";
import { requestedItemIds } from "@/mock/requests";
import ItemRequestToggle from "./ItemRequestToggle";
import ItemDeleteButton from "./ItemDeleteButton";
import ItemCarousel from "@/components/items/ItemCarousel";

type Item = {
  id: number;
  name: string;
  price: number;
  listed: boolean;
  imageUrls?: string[];
  deadline?: string;
  seller?: { name: string; avatarUrl?: string };
};

const ItemDetailView = ({ item }: { item: Item }) => {
  return (
    <Main>
      <Grid>
        <LeftCol>
          <ImageWrap>
            {/* TODO: モック画像複数対応。API接続後も配列で受領する */}
            <ItemCarousel imageUrls={item.imageUrls ?? []} />
          </ImageWrap>
          <InfoSection>
            <Title>{item.name}</Title>
            <Desc>
              この商品はモックデータです。詳細情報は後続のAPI接続で拡張します。
            </Desc>
          </InfoSection>
          <ItemComments itemId={item.id} />
        </LeftCol>
        <Sidebar>
          <Card>
            <ItemPrice price={item.price} />
            <ItemDeadline deadline={item.deadline} />
            <StatusRow>
              <ItemStatusLabel listed={item.listed} />
            </StatusRow>
            <ButtonCol>
              {/* TODO: 認可チェック：出品者本人のみ編集可能。非本人はこのボタンを表示しない or 無効化する */}
              <EditLink href={`/items/${item.id}/edit`}>編集する</EditLink>
              <ItemRequestToggle
                itemId={item.id}
                initialRequested={requestedItemIds.includes(item.id)}
              />
              <ItemDeleteButton itemId={item.id} />
            </ButtonCol>
          </Card>
          <SellerCard>
            <ItemSeller
              name={item.seller?.name}
              avatarUrl={item.seller?.avatarUrl}
            />
          </SellerCard>
        </Sidebar>
      </Grid>
      <BackRow>
        <BackLink href="/items">← 商品一覧に戻る</BackLink>
      </BackRow>
    </Main>
  );
};

const Main = styled.main`
  padding: 24px 24px 48px;
  max-width: 1200px;
  margin: 0 auto;
`;

const Grid = styled.div`
  display: grid;
  gap: 16px;
  align-items: start;
  grid-template-columns: 1fr;
  @media (min-width: 1024px) {
    grid-template-columns: 2fr 1fr;
    gap: 32px;
  }
`;

const LeftCol = styled.div`
  display: grid;
  gap: 20px;
`;

const ImageWrap = styled.div`
  position: relative;
  width: 100%;
  max-width: 840px;
  margin: 0 auto;
  aspect-ratio: 4 / 3;
  background: #f3f4f6;
  border-radius: 12px;
  overflow: hidden;
`;

const InfoSection = styled.section`
  display: grid;
  gap: 8px;
`;

const Title = styled.h1`
  margin: 0 0 4px;
  font-size: 22px;
  font-weight: 800;
`;

const Sidebar = styled.aside`
  position: sticky;
  top: 24px;
  display: grid;
  gap: 16px;
  height: fit-content;
`;

const Desc = styled.p`
  color: #6b7280;
  margin: 0;
`;

const Card = styled.div`
  border: 1px solid #e5e7eb;
  border-radius: 12px;
  padding: 16px;
  background: #fff;
  display: grid;
  gap: 12px;
`;

const StatusRow = styled.div`
  display: flex;
  align-items: center;
`;

const ButtonCol = styled.div`
  display: grid;
  gap: 8px;
`;

const EditLink = styled(Link)`
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 8px 12px;
  border-radius: 8px;
  background: #111827;
  color: #fff;
  font-weight: 700;
  text-decoration: none;
  width: fit-content;
`;

const SellerCard = styled.div`
  border: 1px solid #e5e7eb;
  border-radius: 12px;
  padding: 12px 16px;
  background: #fff;
`;

const BackRow = styled.div`
  margin-top: 32px;
  text-align: center;
`;

const BackLink = styled(Link)`
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  border-radius: 8px;
  border: 1px solid #e5e7eb;
  background: #fff;
  color: #111827;
  text-decoration: none;
`;

export default ItemDetailView;
