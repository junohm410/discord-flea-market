"use client";

import styled from "styled-components";

const Container = styled.main`
  display: grid;
  place-items: center;
  min-height: calc(100dvh - 80px);
  padding: 24px;
`;

const Card = styled.section`
  width: 100%;
  max-width: 560px;
  border-radius: 16px;
  border: 1px solid rgba(0, 0, 0, 0.08);
  background: white;
  padding: 24px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.06);
`;

const Title = styled.h1`
  font-size: 22px;
  font-weight: 700;
  margin: 0 0 8px;
`;

const Description = styled.p`
  color: #555;
  margin: 0 0 16px;
`;

const Button = styled.button`
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 10px 16px;
  border-radius: 8px;
  background: #5865f2; /* Discord brand-ish */
  color: #fff;
  font-weight: 600;
  transition: background 0.2s ease;
  &:hover {
    background: #4752c4;
  }
`;

export default function WelcomePage() {
  const railsOrigin = process.env.NEXT_PUBLIC_RAILS_ORIGIN;

  return (
    <Container>
      <Card>
        <Title>ようこそ</Title>
        <Description>
          Discordメンバー限定のフリマアプリ（UI移行検証用の簡易ページ）
        </Description>

        {railsOrigin ? (
          <form method="post" action={`${railsOrigin}/users/auth/discord`}>
            <Button>Discordアカウントでログイン</Button>
          </form>
        ) : (
          <Description>
            環境変数 <code>NEXT_PUBLIC_RAILS_ORIGIN</code>{" "}
            が未設定です。Railsの起動URLを設定するとログインボタンが有効になります。
          </Description>
        )}
      </Card>
    </Container>
  );
}
