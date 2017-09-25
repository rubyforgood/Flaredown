import DS from 'ember-data';
import Ember from 'ember';

const {
  attr,
  Model,
  hasMany,
  belongsTo,
} = DS;

const {
  A,
  get,
  set,
  RSVP,
  isBlank,
  computed,
  observer,
  isPresent,
  getProperties,
  Logger: { error },
  computed: { and, alias },
} = Ember;

export default Model.extend({
  date: attr('string'),  // please keep this as string as we don't need timezone info
  note: attr('string'),
  tagIds: attr(),
  foodIds: attr(),
  postalCode: attr('string'),
  availableForHbi: attr('boolean'),
  availableForPr: attr('boolean'),
  locationName: attr('string'),
  promotionSkippedAt: attr('string'),

  tags: hasMany('tag', { async: false }),
  foods: hasMany('food', { async: false }),
  symptoms: hasMany('checkinSymptom'),
  conditions: hasMany('checkinCondition'),
  treatments: hasMany('checkinTreatment'),

  weather: belongsTo('weather', { async: false }),
  harveyBradshawIndex: belongsTo('harveyBradshawIndex', { async: false }),
  promotionRate: belongsTo('promotionRate', { async: false }),

  tagsChanged: false,

  shouldShowPrStep: alias('availableForPr'),

  addObj: function(obj, idsKey, relationKey) {
    const objId = parseInt(get(obj, 'id'));

    if (!get(this, idsKey).includes(objId)) {
      get(this, relationKey).pushObject(obj);
      get(this, idsKey).pushObject(objId);
      set(this, 'hasDirtyAttributes', true);
    }
  },

  removeObj: function(obj, idsKey, relationKey) {
    get(this, relationKey).removeObject(obj);
    get(this, idsKey).removeObject(parseInt(get(obj, 'id')));
    set(this, 'hasDirtyAttributes', true);
  },

  deleteTrackablesPreparedForDestroy() {
    const { conditions, symptoms, treatments } = getProperties(this, 'conditions', 'symptoms', 'treatments');

    [conditions, symptoms, treatments].forEach(trackables => {
      trackables.toArray().forEach(trackable => {
        if (get(trackable, 'isPreparedForDestroy')) {
          trackables.removeObject(trackable);

          trackable.deleteRecord();
        }
      });
    });
  },

  handleSaveError(obj) {
    get(this, 'errors')._add(
      'saveFailure',
      ['Checkin save failed!<br>Please check your connection and then refresh the page.']
    );

    error(obj);
  },

  isBlank: and('conditionsBlank', 'symptomsBlank', 'treatmentsBlank', 'tagsBlank', 'noteBlank'),

  formattedDate: computed('date', function() {
    return moment(get(this, 'date')).format("YYYY-MM-DD");
  }),

  conditionsBlank: computed('conditions', 'conditions.[]', function() {
    return get(this, 'conditions').toArray().filter(function(condition) {
      return isPresent(get(condition, 'value'));
    }).length === 0;
  }),

  symptomsBlank: computed('symptoms', 'symptoms.[]', function() {
    return get(this, 'symptoms').toArray().filter(function(symptom) {
      return isPresent(get(symptom, 'value'));
    }).length === 0;
  }),

  treatmentsBlank: computed('treatments', 'treatments.[]', function() {
    return get(this, 'treatments').toArray().filter(function(treatment) {
      return get(treatment, 'isTaken');
    }).length === 0;
  }),

  tagsBlank: computed('tags', 'tags.[]', function() {
    return get(this, 'tags').toArray().length === 0;
  }),

  noteBlank: computed('note', function() {
    return isBlank(get(this, 'note'));
  }),

  allColorIds: computed('conditions', 'symptoms', 'treatments', function() {
    let result = A();

    result.pushObjects(get(this, 'conditions').mapBy('colorId'));
    result.pushObjects(get(this, 'symptoms').mapBy('colorId'));
    result.pushObjects(get(this, 'treatments').mapBy('colorId'));

    return result;
  }),

  conditionsObserver: observer('conditions', 'conditions.[]', function() {
    if (!get(this, 'availableForHbi')) {
      return;
    }

    get(this, 'conditions')
      .then(conditions => RSVP.all(conditions.map(c => get(c, 'condition'))))
      .then(conditions => set(
        this,
        'shouldShowHbiStep',
        conditions.any(condition => get(condition, 'name') === "Crohn's disease")
      ));
  }),
});
