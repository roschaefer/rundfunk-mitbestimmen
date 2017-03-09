import Ember from 'ember';

export function htmlForTableReference(params) {
  let [trash, unlock, lock, euro] = params;
  let html = '<div class="ui list"> <div class="item"> <i class="icon trash"></i> <div class="content"> ';
  html += trash;
  html += '</div> </div> <div class="item"> <i class="icon linkify"></i> <div class="content">';
  html += unlock;
  html += ' </div> </div> <div class="item"> <i class="icon unlinkify"></i> <div class="content">';
  html += lock;
  html += '</div> </div> <div class="item"> <i class="icon euro"></i> <div class="content">';
  html += euro;
  html += ' </div> </div> </div> ';
  return html;
}

export default Ember.Helper.helper(htmlForTableReference);
