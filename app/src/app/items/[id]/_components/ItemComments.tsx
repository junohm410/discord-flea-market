"use client";

import styled from "styled-components";
import { mockComments } from "@/mock/comments";

type Props = { itemId: number };

const ItemComments = ({ itemId }: Props) => {
  return (
    <Section>
      <h2>コメント</h2>
      <List>
        {mockComments
          .filter((c) => c.itemId === itemId)
          .map((c) => (
            <li key={c.id}>
              <Author>{c.author}</Author>
              <Body>{c.body}</Body>
            </li>
          ))}
      </List>
      <Form
        onSubmit={(e) => {
          e.preventDefault();
          // TODO: BFF経由でRails APIへPOST。今はモックでalert
          alert("コメント送信（モック）");
        }}
      >
        <Input placeholder="コメントを書く..." />
        <Submit>送信</Submit>
      </Form>
    </Section>
  );
};

const Section = styled.section`
  grid-column: 1 / -1;
  display: grid;
  gap: 8px;
`;

const List = styled.ul`
  list-style: none;
  padding: 0;
  margin: 0;
  display: grid;
  gap: 8px;
`;

const Author = styled.span`
  font-weight: 700;
  margin-right: 8px;
`;

const Body = styled.span`
  color: #374151;
`;

const Form = styled.form`
  display: grid;
  grid-template-columns: 1fr auto;
  gap: 8px;
`;

const Input = styled.input`
  padding: 10px 12px;
  border-radius: 8px;
  border: 1px solid rgba(0, 0, 0, 0.15);
  background: #fff;
`;

const Submit = styled.button`
  padding: 10px 16px;
  border-radius: 8px;
  background: #111827;
  color: #fff;
  font-weight: 700;
`;

export default ItemComments;
