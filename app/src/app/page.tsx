"use client";

import styled from "styled-components";

const Home = () => {
  const railsOrigin = process.env.NEXT_PUBLIC_RAILS_ORIGIN;

  return (
    <Container>
      <Content>
        <Title>Discord Flea Market</Title>
        <Tagline>
          サーバー内メンバー専用の
          <br />
          フリーマーケットへようこそ
        </Tagline>

        <div>
          <Lead>
            不要になったものを、必要な人へ。
            <br />
            公平な自動抽選でマッチングします。
          </Lead>
        </div>

        <FeaturesCard>
          <FeaturesTitle>このアプリの特徴</FeaturesTitle>
          <Features>
            <FeatureRow>
              <FeatureLabel>締切日設定：</FeatureLabel>
              <FeatureText>出品時に購入希望の締切日を設定できます</FeatureText>
            </FeatureRow>
            <FeatureRow>
              <FeatureLabel>公平な抽選：</FeatureLabel>
              <FeatureText>複数の希望者から自動でランダムに選定</FeatureText>
            </FeatureRow>
            <FeatureRow>
              <FeatureLabel>Discord通知：</FeatureLabel>
              <FeatureText>抽選結果は自動でDiscordに通知されます</FeatureText>
            </FeatureRow>
            <FeatureRow>
              <FeatureLabel>安心のマッチング：</FeatureLabel>
              <FeatureText>
                メンバー限定で信頼できる相手を見つけられます
              </FeatureText>
            </FeatureRow>
          </Features>
        </FeaturesCard>

        <Actions>
          {railsOrigin ? (
            <form method="post" action={`${railsOrigin}/users/auth/discord`}>
              <Button>Discordアカウントでログイン</Button>
            </form>
          ) : (
            <Caption>
              環境変数 <code>NEXT_PUBLIC_RAILS_ORIGIN</code>{" "}
              が未設定です。設定するとログインボタンが有効になります。
            </Caption>
          )}
          <Caption>
            ※対象は事前に許可されたDiscordサーバーメンバーのみです
          </Caption>
        </Actions>
      </Content>
    </Container>
  );
};

const Container = styled.main`
  display: grid;
  place-items: center;
  min-height: 70vh;
  padding: 24px;
`;

const Content = styled.section`
  width: 100%;
  max-width: 720px;
  text-align: center;
  display: grid;
  gap: 24px;
`;

const Title = styled.h1`
  margin: 0;
  color: #111827; /* gray-900 */
  font-weight: 800;
  font-size: 32px;
  line-height: 1.2;
  @media (min-width: 1024px) {
    font-size: 40px;
  }
`;

const Tagline = styled.p`
  margin: 0;
  color: #4b5563; /* gray-600 */
  font-size: 18px;
  font-weight: 600;
`;

const Lead = styled.p`
  margin: 0;
  color: #6b7280; /* gray-500 */
  font-size: 16px;
  line-height: 1.8;
  @media (min-width: 1024px) {
    font-size: 18px;
  }
`;

const FeaturesCard = styled.div`
  background: #eef2ff; /* primary-50-ish */
  border-radius: 12px;
  padding: 24px;
  text-align: left;
  max-width: 640px;
  margin: 0 auto;
`;

const FeaturesTitle = styled.h2`
  margin: 0 0 12px;
  color: #1e3a8a; /* primary-900-ish */
  font-size: 18px;
  font-weight: 700;
`;

const Features = styled.div`
  display: grid;
  gap: 12px;
  font-size: 14px;
  @media (min-width: 1024px) {
    font-size: 16px;
  }
`;

const FeatureRow = styled.div`
  display: flex;
  align-items: flex-start;
  gap: 12px;
`;

const FeatureLabel = styled.span`
  color: #4338ca; /* primary-600-ish */
  font-weight: 700;
  min-width: 100px;
`;

const FeatureText = styled.p`
  margin: 0;
  color: #1f2937; /* primary-800-ish */
`;

const Actions = styled.div`
  display: grid;
  gap: 12px;
  place-items: center;
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

const Caption = styled.p`
  margin: 0;
  color: #4b5563; /* gray-600 */
  font-size: 12px;
`;

export default Home;
