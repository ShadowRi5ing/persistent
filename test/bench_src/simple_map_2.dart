// Copyright 2012 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Author: Paul Brauner (polux@google.com)

/**
 * Naive implementation of ImmutableMap dart:core [Map]s.
 */
class SimpleImmutableMap2<K, V> extends ImmutableMapBase<K, V> {
  final Map<K, V> _map;

  SimpleImmutableMap2._internal(this._map);
  factory SimpleImmutableMap2() =>
      new SimpleImmutableMap2._internal(new Map<K, V>());

  ImmutableMap<K, V> insert(K key, V value, [V combine(V x, V y)]) {
    combine = (combine != null) ? combine : (V x, V y) => y;
    Map<K, V> newmap = new Map<K, V>.from(_map);
    newmap[key] = _map.containsKey(key) ? combine(_map[key], value) : value;
    return new SimpleImmutableMap2._internal(newmap);
  }

  ImmutableMap<K, V> delete(K key) {
    Map<K, V> newmap = new Map<K, V>.from(_map);
    newmap.remove(key);
    return new SimpleImmutableMap2._internal(newmap);
  }

  Option<V> lookup(K key) {
    if (_map.containsKey(key)) {
      return new Option<V>.some(_map[key]);
    } else {
      return new Option<V>.none();
    }
  }

  ImmutableMap mapValues(f(V)) {
    Map newmap = new Map.from(_map);
    _map.forEach((K key, V value) {
      newmap[key] = f(value);
    });
    return new SimpleImmutableMap2._internal(newmap);
  }

  ImmutableMap<K, V> adjust(K key, V update(V)) {
    if (_map.containsKey(key)) {
      Map newmap = new Map.from(_map);
      newmap[key] = update(_map[key]);
      return new SimpleImmutableMap2._internal(newmap);
    }
    return this;
  }

  void forEach(f(K, V)) {
    _map.forEach(f);
  }

  String toString() => _map.toString();

  int size() => _map.length;

  ImmutableMap<K, V> union(ImmutableMap<K, V> other, [V combine(V x, V y)]) {
    throw "not implemented";
  }
}
