<template>
	<!-- #ifdef APP-PLUS || H5 -->
	<checkbox-group :name="name">
		<slot></slot>
	</checkbox-group>
	<!-- #endif -->

	<!-- #ifndef APP-PLUS || H5 -->
	<tui-form-field :name="name" :value="vals">
		<slot></slot>
	</tui-form-field>
	<!-- #endif -->
</template>

<script>
	export default {
		name: "tui-checkbox-group",
		behaviors: ['uni://form-field-group'],
		props: {
			name: {
				type: String,
				default: ''
			},
			value: {
				type: Array,
				default () {
					return []
				}
			}
		},
		data() {
			return {
				vals: ''
			};
		},
		created() {
			this.childrens = []
		},
		methods: {
			checkboxChange(e) {
				this.$emit('change', e)
				this.$emit('input', e.detail.value)
			},
			changeValue(checked, target) {
				let vals = []
				this.childrens.forEach(item => {
					if (item.val) {
						vals.push(item.value);
					}
				})
				this.vals = vals;
				let e = {
					detail: {
						value: vals
					}
				}
				this.checkboxChange(e)
			}
		}
	}
</script>

<style></style>
