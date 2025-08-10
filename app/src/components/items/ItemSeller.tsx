"use client";

import styled from "styled-components";

type Props = {
  name?: string;
  avatarUrl?: string;
};

const ItemSeller = ({ name, avatarUrl }: Props) => {
  if (!name && !avatarUrl) return null;
  return (
    <Wrap>
      <Avatar src={avatarUrl || "/favicon.ico"} alt="avatar" />
      <div>
        <Label>出品者</Label>
        <Name>{name || "Unknown"}</Name>
      </div>
    </Wrap>
  );
};

const Wrap = styled.div`
  display: flex;
  align-items: center;
  gap: 12px;
`;

const Avatar = styled.img`
  width: 48px;
  height: 48px;
  border-radius: 999px;
  background: #f3f4f6;
  box-shadow: 0 0 0 2px #e5e7eb inset;
`;

const Label = styled.div`
  font-size: 12px;
  color: #6b7280;
`;

const Name = styled.div`
  font-weight: 700;
  color: #111827;
`;

export default ItemSeller;
