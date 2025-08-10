"use client";

import styled from "styled-components";

const ItemDeleteButton = ({ itemId }: { itemId: number }) => {
  return (
    <DangerButton
      type="button"
      onClick={() => {
        if (confirm("本当に削除しますか？")) {
          // TODO: BFF 経由で DELETE /api/items/:id を呼び出し、完了後は一覧へ遷移
          alert(`商品を削除しました（モック）: item ${itemId}`);
        }
      }}
    >
      商品を削除する
    </DangerButton>
  );
};

const DangerButton = styled.button`
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 10px 16px;
  border-radius: 8px;
  background: #dc2626; /* red-600 */
  color: #fff;
  font-weight: 700;
`;

export default ItemDeleteButton;
