"use client";

import styled from "styled-components";

type PaginationProps = {
  page: number;
  totalPages: number;
  onPrev: () => void;
  onNext: () => void;
  canPrev: boolean;
  canNext: boolean;
  className?: string;
};

const Pagination = ({
  page,
  totalPages,
  onPrev,
  onNext,
  canPrev,
  canNext,
  className,
}: PaginationProps) => {
  if (totalPages <= 1) return null;
  return (
    <Wrap className={className}>
      <Button type="button" disabled={!canPrev} onClick={onPrev}>
        前へ
      </Button>
      <PageText>
        {page}/{totalPages}
      </PageText>
      <Button type="button" disabled={!canNext} onClick={onNext}>
        次へ
      </Button>
    </Wrap>
  );
};

const Wrap = styled.div`
  margin-top: 16px;
  display: flex;
  gap: 8px;
  justify-content: center;
  align-items: center;
`;

const PageText = styled.span`
  font-size: 12px;
  color: #6b7280;
`;

const Button = styled.button`
  padding: 8px 12px;
  border-radius: 8px;
  border: 1px solid #e5e7eb;
  background: #fff;
  color: #111827;
  &:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
`;

export default Pagination;
