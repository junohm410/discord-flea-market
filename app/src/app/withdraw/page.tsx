"use client";

import styled from "styled-components";

const WithdrawPage = () => {
  const onSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    // TODO: Rails API のユーザー削除にBFF経由でPOST/DELETE
    const confirmed = window.confirm(
      "過去のものを含む自分の出品・購入希望のデータが削除されます。本当に退会しますか？"
    );
    if (confirmed) {
      alert("未接続（モック）。API接続後に退会処理を実装します。");
    }
  };

  return (
    <Main>
      <Toolbar>
        <Title>退会</Title>
      </Toolbar>
      <Content>
        <p>
          退会すると、過去のものを含む自分の出品・購入希望のデータが削除されます。本当に退会しますか？
        </p>
        <form onSubmit={onSubmit}>
          <DangerButton type="submit">退会する（モック）</DangerButton>
        </form>
      </Content>
    </Main>
  );
};

const Main = styled.main`
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

const Content = styled.section`
  display: grid;
  gap: 16px;
  max-width: 720px;
`;

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

export default WithdrawPage;
