import { Controller } from "@hotwired/stimulus";
import Splide from "@splidejs/splide";

export default class extends Controller {
  connect() {
    new Splide(".splide", {
      type: "loop",
      perPage: 1,
      arrows: true,
      pagination: true,
      width: "100%",
    }).mount();
  }
}
