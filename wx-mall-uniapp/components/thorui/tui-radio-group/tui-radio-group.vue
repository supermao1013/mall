<template>
	<!-- #ifdef APP-PLUS || H5 -->
	<radio-group :name="name">
		<slot></slot>
	</radio-group>
	<!-- #endif -->

	<!-- #ifndef APP-PLUS || H5 -->
	<tui-form-field :name="name" :value="val">
		<slot></slot>
	</tui-form-field>
	<!-- #endif -->
</template>

<script>
	export default {
		name: "tui-radio-group",
		behaviors: ['uni://form-field-group'],
		props: {
			name: {
				type: String,
				default: ''
			},
			value: {
				type: String,
				default: ''
			}
		},
		data() {
			return {
				val: ''
			}
		},
		created() {
			this.childrens = []
		},
		methods: {
			radioChange(e) {
				this.$emit('change', e)
				this.$emit('input', e.detail.value)
			},
			changeValue(value, target) {
				this.val = value;
				this.childrens.forEach(item => {
					if (item !== target) {
						item.val = false;
					}
				})
				let e = {
					detail: {
						value: value
					}
				}
				this.radioChange(e)
			}
		}
	}
</script>
<style></style>