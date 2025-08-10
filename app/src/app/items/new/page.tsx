import ItemForm from "./_components/ItemForm";

export default function NewItemPage() {
  // TODO: 提出時はBFF経由でRails APIへPOST（CSRF/Cookie/JSON or multipart対応）
  return <ItemForm />;
}
