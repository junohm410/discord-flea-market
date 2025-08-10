"use client";

import styled from "styled-components";

export default function ItemStatusLabel({ listed }: { listed: boolean }) {
  return <Root $listed={listed}>{listed ? "出品中" : "取引中/終了"}</Root>;
}

const Root = styled.span<{ $listed: boolean }>`
  font-size: 12px;
  padding: 2px 8px;
  border-radius: 999px;
  color: ${({ $listed }) => ($listed ? "#065f46" : "#92400e")};
  background: ${({ $listed }) => ($listed ? "#d1fae5" : "#fef3c7")};
`;
