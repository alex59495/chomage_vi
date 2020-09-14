import flatpickr from "flatpickr";
import {French} from 'flatpickr/dist/l10n/fr.js';

const flat_picker = () => {
  flatpickr(".datepicker", {
    altInput: true,
    locale: French,
  });
}

export default flat_picker
