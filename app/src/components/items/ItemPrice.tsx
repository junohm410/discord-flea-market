"use client";

import styled from "styled-components";

export type ItemPriceProps = {
  price: number;
  className?: string;
};

const ItemPrice = ({ price, className }: ItemPriceProps) => {
  return <Root className={className}>¥{price.toLocaleString()}</Root>;
};

const Root = styled.span`
  font-size: 20px;
  font-weight: 800;
`;

export default ItemPrice;
