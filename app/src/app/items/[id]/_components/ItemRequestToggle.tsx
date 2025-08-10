"use client";

import { useState } from "react";
import styled from "styled-components";

type Props = {
  itemId: number;
  initialRequested: boolean;
};

const ItemRequestToggle = ({ itemId, initialRequested }: Props) => {
  const [requested, setRequested] = useState(initialRequested);

  return (
    <Row>
      {/* TODO: BFF 経由で /api/items/:id/requests を POST/DELETE。未ログイン時はログイン導線へ */}
      {requested ? (
        <SecondaryButton
          type="button"
          onClick={() => {
            setRequested(false);
            alert(`購入希望を取り消しました（モック）: item ${itemId}`);
          }}
        >
          購入希望を取り消す
        </SecondaryButton>
      ) : (
        <PrimaryButton
          type="button"
          onClick={() => {
            setRequested(true);
            alert(`購入希望を出しました（モック）: item ${itemId}`);
          }}
        >
          購入希望を出す
        </PrimaryButton>
      )}
    </Row>
  );
};

const Row = styled.div`
  display: flex;
  gap: 12px;
`;

const PrimaryButton = styled.button`
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 10px 16px;
  border-radius: 8px;
  background: #111827;
  color: #fff;
  font-weight: 700;
`;

const SecondaryButton = styled.button`
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 10px 16px;
  border-radius: 8px;
  background: #f3f4f6;
  color: #111827;
  font-weight: 700;
`;

export default ItemRequestToggle;
