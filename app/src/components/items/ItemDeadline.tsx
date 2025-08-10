"use client";

import styled from "styled-components";

const ItemDeadline = ({ deadline }: { deadline?: string }) => {
  if (!deadline) return null;

  const d = new Date(deadline);
  const diffMs = d.getTime() - Date.now();
  const days = Math.ceil(diffMs / (1000 * 60 * 60 * 24));
  const formatter = new Intl.DateTimeFormat("ja-JP", {
    timeZone: "Asia/Tokyo",
    year: "numeric",
    month: "numeric",
    day: "numeric",
    hour: "numeric",
    minute: "numeric",
    second: "numeric",
    hour12: false,
  });

  const label = isNaN(days)
    ? formatter.format(d)
    : days >= 0
    ? `締切まで${days}日`
    : `締切済み`;

  return (
    <Wrap>
      <Badge>{label}</Badge>
      <Text>{formatter.format(d)}</Text>
    </Wrap>
  );
};

const Wrap = styled.div`
  margin: 8px 0 12px;
`;

const Badge = styled.span`
  display: inline-block;
  font-size: 12px;
  padding: 2px 8px;
  border-radius: 999px;
  background: #eef2ff;
  color: #1e3a8a;
  font-weight: 700;
  margin-right: 8px;
`;

const Text = styled.span`
  color: #6b7280;
`;

export default ItemDeadline;
