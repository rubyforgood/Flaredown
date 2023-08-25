import resolver from './helpers/resolver';
import {
  setResolver
} from 'ember-qunit';
import Application from '../app';
import config from '../config/environment';
import { setApplication } from '@ember/test-helpers';
import { start } from 'ember-qunit';

setApplication(Application.create(config.APP));
setResolver(resolver);

start();
