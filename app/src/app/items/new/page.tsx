import ItemUpsertForm from "@/components/items/ItemUpsertForm";

const NewItemPage = () => {
  // TODO: 提出時はBFF経由でRails APIへPOST（CSRF/Cookie/JSON or multipart対応）
  return <ItemUpsertForm mode="create" />;
};

export default NewItemPage;
